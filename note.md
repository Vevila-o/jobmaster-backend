## 學習筆記

1. rails 

    > bug : rails -v

    這個是因為我是用rbenv來安裝ruby還有rails，不是直接建在系統環境裡（之前windows是裝在本機環境）導致指令抓不到，因為**路徑不對** 
    要執行來建立影子指令：
    ```
    rbenv rehash
    ```
    產生對應的shim檔案

2. git
    使用者資訊之前都不會去做更改，github登入完就懶得動了
    ```
    git config user.name "你的名字"
    git config user.email "vevila@5xruby.com"
    ```

3. bundle
    是一個專門for ruby的套件管理工具，有點像之前碰的
    ```
    python install -r requirement.txt
    ```
    就是把指定的套件與版本下載下來，避免每個人不一樣，不過bundle就是一個可以對齊的工具
    一些相關的指令：
    ```
    bundle install          # 依照 Gemfile 安裝所有 gem
    bundle update rails     # 只更新 rails 這個 gem 到符合條件的最新版
    bundle update           # 更新所有 gem
    bundle exec rails server  # 用 Bundler 管理的版本執行 rails 指令
    ```


4. Windows macos 
因為不想要帶兩台電腦，有時候會切換著使用，以macos為主的話，windows要另外裝一個linux環境>> wsl

5. Ruby `private` 是開關，不是修飾詞（跟 Java 不一樣）
    > bug : create 明明寫了，Rails 卻說 `The action 'create' could not be found`

    Java 的 `private`/`public` 是寫在每個方法前面，各自獨立、互不影響。
    Ruby 的 `private` 是一個**狀態開關**，執行到這行之後、同一個 class body 裡**所有**後面定義的方法都會變成 private，直到遇到 `public`/`protected` 或 class 結束為止，跟中間隔多少行、有沒有註解都沒關係。
    Rails 判斷 action 能不能被路由呼叫，看的是這個 method 是不是 **public**，一旦不小心把 action 寫在 `private` 下面，就會找不到這個 action。
    ```ruby
    # 錯誤：create 寫在 private 之後，變成私有方法
    private
    def task_params; end
    def create; end   # 也被算進 private 範圍

    # 正確：所有 action 都寫在 private 之前
    def create; end
    private
    def task_params; end
    ```

6. Turbo 底下刪除連結要用 `turbo_method`，不是 `method`
    > bug : 按刪除卻跳出 `AbstractController::ActionNotFound (The action 'show' could not be found)`

    專案用的是 `turbo-rails`（Hotwire），不是舊版的 `rails-ujs`。`link_to` 的 `method:` 選項是 rails-ujs 的寫法，Turbo 底下會被完全忽略，連結變成普通 GET，打到 `show`（不存在）而不是 `destroy`。
    ```erb
    <%# 錯誤，Turbo 不吃這個 %>
    <%= link_to "刪除", task_path(task), method: "delete" %>

    <%# 正確 %>
    <%= link_to "刪除", task_path(task), data: { turbo_method: :delete, turbo_confirm: "確認刪除" } %>
    ```

7. `redirect_to @task` 背後其實是 `task_path(@task)`
    `redirect_to` 收到 model 物件時，會自動用 polymorphic routing 轉成對應的路徑（等同 `task_path(@task)`），所以一樣需要有 `show` action 才不會出錯。`destroy` 完之後不該 `redirect_to @task`（該筆資料都刪了），應該導回列表 `redirect_to tasks_path`。

8. Flash message 要自己在 layout 印出來，且 each 要包 `do...end`
    > bug : `notice:` 有帶，畫面卻完全看不到

    `redirect_to path, notice: "xxx"` 只是把訊息存進 `flash[:notice]`，layout 沒有主動把 `flash` 印出來的話，什麼都不會顯示。而且 Ruby block 語法一定要有 `do`（`flash.each |type, msg|` 是錯的，要 `flash.each do |type, msg|`），也不能忘記 `<% end %>`。
    ```erb
    <% flash.each do |type, msg| %>
      <div class="flash flash-<%= type %>"><%= msg %></div>
    <% end %>
    ```

9. `enum` 只能定義在 model，不能放在 controller 或 migration
    > bug : `NoMethodError: undefined method 'enum' for class 'XxxController'`（或 migration 也一樣）

    `enum` 是 ActiveRecord（model）專屬的 class method。Controller 繼承 `ApplicationController`、migration 繼承 `ActiveRecord::Migration`，都不是 model，沒有這個方法可用。
    ```ruby
    # app/models/user.rb 才是對的地方
    class User < ApplicationRecord
      enum :role, { "一般使用者": 0, "管理者": 1 }
    end
    ```
    另外要注意：migration 只負責描述資料庫結構（`create_table`/`add_column`），且**已經跑過的 migration 改了也不會重新套用**，想加欄位要開新的 migration。

10. Mass Assignment 資安：不能隨便 permit `role` 這種權限欄位
    > Brakeman warning: `Potentially dangerous key allowed for mass assignment`

    如果 `params.require(:user).permit(:name, :email, :role)` 讓一般使用者的 `update` 也能改到 `role`，等於任何人都能把自己送出 `role: 管理者` 而變成 admin（就算表單畫面上沒放這個欄位，直接送 request 一樣繞得過去）。
    正確做法：一般的 `user_pramas` 不該有 `role`；要開放給管理者改 role，得先有 `current_user` + 權限判斷（例如 `current_user&.管理者?`）之後才能把 `:role` 放進白名單，而且這個判斷要在**寫入前**真的擋下來，不是只把方法定義出來擺著。

11. RSpec：`tasks_path`、`post` 這些 helper 為什麼用不到
    > bug : `NameError: undefined local variable or method 'tasks_path'`

    request spec 才有路由 helper（`tasks_path`）和 HTTP 方法（`post`/`patch`）可以用，一般的 model spec 沒有。RSpec-Rails 判斷 spec 類型有兩種方式：明確標記 `type: :request`，或是靠**檔案路徑**自動判斷（放在 `spec/requests/` 底下），但後者要先把 `rails_helper.rb` 裡的
    ```ruby
    config.infer_spec_type_from_file_location!
    ```
    這行的註解拿掉才會生效。混在同一支檔案、又沒標記 `type: :request` 的話，就會被當成單純的 model spec 執行。

12. `expect(x)` 沒接 `.to` matcher，等於沒斷言
    寫 `expect(user.role)` 就結束，沒有接 `.to eq(...)` 之類的 matcher，這行**完全不會驗證任何東西**，測試永遠不會因為這行失敗，等於白寫。

13. 有 `enum` 的欄位，讀出來是字串 key，不是原本傳進去的整數
    ```ruby
    enum :role, { "一般使用者": 0, "管理者": 1 }
    User.new(role: 1).role   # => "管理者"，不是 1
    ```
    寫入時可以傳整數（對應 enum 定義的值），但讀取 `.role` 拿到的一律是字串 key，斷言時要比對字串（或用 enum 自動產生的 `user.管理者?` predicate），不能寫 `expect(user.role).to eq(1)`。

14. 準備測試資料要用 `create!`，不要用 `update`
    `Model.update(attrs)` 是 class method，簽名其實是 `update(id, attrs)`，沒帶 id 會直接噴 `ArgumentError`。測試裡想「先準備一筆資料」應該用：
    ```ruby
    task = Task.create!(title: "before")
    ```
    `update` 是拿來測「修改」這個行為本身的（透過 `patch` request），不是拿來造測試資料的工具。

15. 透過 HTTP request 改了資料庫，手上的 Ruby 物件不會自動更新，要 `reload`
    ```ruby
    task = Task.create!(title: "before")
    patch task_path(task), params: { task: { title: "after" } }
    task.title      # 還是 "before"！
    task.reload
    task.title      # 這時候才是 "after"
    ```
    物件是建立當下的記憶體快照，跟資料庫之間不會自動同步，斷言前一定要 `reload`。

16. Path helper 分不清「集合」跟「單一資源」，PATCH/POST 常常打錯路由
    - `tasks_path` / `users_path`：對應 `/tasks`、`/users`，**不吃 id**，給 index、還有新增（`create`，資源還不存在，本來就沒有 id）用
    - `task_path(task)` / `user_path(user)`：對應 `/tasks/:id`、`/users/:id`，**需要帶 id**，給 show/update/destroy（已存在的資源）用
    新增（`POST`）要打集合路由 `users_path`；修改/刪除（`PATCH`/`DELETE`）要打單一資源路由 `user_path(user)`。另外，斷言 `redirect_to` 要跟 controller 實際寫的一致，例如 `create` 若是 `redirect_to user_path(@user)`，測試就不能寫成 `redirect_to(users_path)`，要用 `user_path(User.last)`。
17. RSpec 的 `expect` 只能寫在 `it` 區塊裡，不能直接寫在 `describe` 底下

> bug : `expect is not available on an example group (e.g. a describe or context block)`

`describe`／`context` 只是拿來分類、命名一群測試，實際要驗證的程式碼一定要包在 `it "..." do ... end` 裡面才有作用，漏寫 `it` 或 `do`/`end` 沒對齊都會出這個錯。
