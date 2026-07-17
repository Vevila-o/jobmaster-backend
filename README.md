# jobmaster-backend README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: **3.3.11**
* System dependencies

* Configuration

* Database creation
### USER 使用者

| id | name | role |email | password | 
| --- | --- | --- | --- | --- |
| int | string | int | string | string 

### TASK 任務
| id | title | content | start_time | end_time | task |priority | created_time | user_id
| --- | --- | --- | --- | --- | --- | --- | --- | ---
| int | string | string | datetime | datetime | int | int | datetime | int

### TAG 標籤

| id | name | 
| --- | --- | 
| int | string |

### TASKTAG 任務標籤中介表

| task_id | tag_id |  
| --- | --- | 
| int | int |



* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
