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
