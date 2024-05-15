# Task Name and Task ID

## Task Name List View
**GET** `/api/task-name/`  
Return all task results.

## Task Name Item View
**GET** `/api/task-name/<task-name>/`  
Return all ask results by task name

**POST** `/api/task-name/<task-name>/`  
Start a new task by task name, only tasks without arguments can be started like that, see `home.tasks.BaseTask.TASK_CONFIG` for more info.

## Task ID view
**GET** `/api/task-id/<task-id>/`  
Return task status by task ID

**POST** `/api/task-id/<task-id>/`
```json
{
    "command": "stop|kill"
}
```
Send command to a task, valid commands: `stop` and `kill`. Not all tasks implement these commands `home.tasks.BaseTask.TASK_CONFIG` for details.

## Schedule View
**DEL** `/api/schedule/`  

Delete schedule by task name

Parameter:

- `task_name`: See task config module

## Schedule Notification View
**GET** `/api/schedule/notification/`

Get a list of all task schedule notifications 

**DEL** `/api/schedule/notification/`

Delete notification of a task.

Parameter:

- `task_name`: See task config module
- `url`: Url to be deleted
