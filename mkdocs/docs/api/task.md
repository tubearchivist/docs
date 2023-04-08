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
