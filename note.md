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

5. 本地分支名稱跟遠端分支名稱不一定要一樣
    > bug : 本地分支明明已經 push 過內容，但 `git branch -vv` 卻顯示沒有設定上游，push 時也不確定該打哪個分支名稱

    這次才發現，本地開發用的分支叫 `pr7_fix`，但遠端實際上開 PR 的分支叫 `topic`，兩個名字雖然不同，內容卻是同一條開發線。以前一直以為本地跟遠端的分支名稱一定要完全一樣才能對應，其實只要用 `git push origin 本地分支:遠端分支` 這種寫法，就能把本地的修正推到指定的遠端分支上，不需要名稱一致，也不用另外開一個同名分支。如果希望以後每次都能直接打 `git push` 而不用打全名，可以在第一次 push 時加上 `-u` 建立追蹤關係，之後 git 就會記得這個對應。

6. 不小心 commit 進去的空檔案怎麼處理
    > bug : 用 `rails generate` 產生 controller 的時候，會順便自動產生對應的 helper 檔案（例如 `tasks_helper.rb`），這種內容是空的檔案很容易沒注意到就一起 commit、push 上去了

    一開始以為檔案既然已經 push 到遠端，想拿掉就得想辦法把歷史紀錄改掉，甚至要 force push，後來才理解沒有這麼麻煩。只要檔案內容沒有機密資料，最單純也最安全的做法，是直接在下一次的 commit 裡用 `git rm` 把檔案標記成刪除，讓新的 commit 記錄「這個檔案被移除了」，照平常方式 push 上去就好；舊的 commit 歷史裡檔案還是會存在，但這是正常現象，不影響專案運作，也不會動到協作者的分支。真的要用改寫歷史（rebase）再 force push 的時機，只有在檔案牽涉到金鑰、密碼這類機密資料時才需要考慮，而且動手前要先確認沒有人已經拉過這個分支。
