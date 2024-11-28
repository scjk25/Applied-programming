import java.util.* 

data class Task(
    val id: Int,
    val description: String,
    var isCompleted: Boolean = false
)

class ToDoList {
    private val tasks = mutableListOf<Task>()
    private var nextId = 1

    fun addTask(description: String) {
        if (description.isBlank()) {
            println("Task description cannot be empty!")
            return
        }
        val task = Task(nextId++, description)
        tasks.add(task)
        println("Task added: ${task.id} - ${task.description}")
    }

    fun markTaskAsDone(taskId: Int) {
        val task = tasks.find { it.id == taskId }
        if (task == null) {
            println("Task with ID $taskId not found.")
            return
        }
        if (task.isCompleted) {
            println("Task with ID $taskId is already marked as completed.")
        } else {
            task.isCompleted = true
            println("Task ${task.id} marked as completed.")
        }
    }

    fun listTasks(showCompleted: Boolean = false) {
        val filteredTasks = if (showCompleted) {
            tasks.filter { it.isCompleted }
        } else {
            tasks.filter { !it.isCompleted }
        }

        if (filteredTasks.isEmpty()) {
            println("No ${if (showCompleted) "completed" else "pending"} tasks.")
        } else {
            println("${if (showCompleted) "Completed" else "Pending"} tasks:")
            filteredTasks.forEach { task ->
                println("${task.id}. ${task.description} [${if (task.isCompleted) "Done" else "Pending"}]")
            }
        }
    }
}

fun main() {
    val scanner = Scanner(System.`in`)
    val toDoList = ToDoList()
    var running = true

    println("Welcome to the To-Do List App")
    println("================================")
    println("Commands:")
    println("1. Add a task")
    println("2. Mark a task as done")
    println("3. Show pending tasks")
    println("4. Show completed tasks")
    println("5. Exit")
    println("================================")

    while (running) {
        print("\nEnter your choice: ")
        val choice = scanner.nextLine().toIntOrNull()

        when (choice) {
            1 -> {
                print("Enter task description: ")
                val description = scanner.nextLine()
                toDoList.addTask(description)
            }
            2 -> {
                print("Enter the task ID to mark as done: ")
                val taskId = scanner.nextLine().toIntOrNull()
                if (taskId == null) {
                    println("Invalid input. Please enter a valid task ID.")
                } else {
                    toDoList.markTaskAsDone(taskId)
                }
            }
            3 -> {
                toDoList.listTasks(showCompleted = false)
            }
            4 -> {
                toDoList.listTasks(showCompleted = true)
            }
            5 -> {
                running = false
                println("Exiting the To-Do List App. Goodbye!")
            }
            else -> {
                println("Invalid choice. Please try again.")
            }
        }
    }
}
