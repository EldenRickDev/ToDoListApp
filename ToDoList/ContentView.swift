//
//  ContentView.swift
//  ToDoList
//
//  Created by Ricardo Andrés Gatica Collarte on 21-08-24.
//

import SwiftUI

// Modelo de datos para una tarea
struct Task: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
}

// Modelo de datos para la lista de tareas
class TaskList: ObservableObject {
    @Published var tasks: [Task] = []

    func addTask(title: String) {
        let newTask = Task(title: title, isCompleted: false)
        tasks.append(newTask)
    }

    func removeTasks(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }

    func toggleCompletion(for task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
}
struct ContentView: View {
    @StateObject private var taskList = TaskList()
    @State private var newTaskTitle = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("New Task", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: {
                        guard !newTaskTitle.isEmpty else { return }
                        taskList.addTask(title: newTaskTitle)
                        newTaskTitle = ""
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }

                List {
                    ForEach(taskList.tasks) { task in
                        HStack {
                            Text(task.title)
                                .strikethrough(task.isCompleted, color: .black)
                                .foregroundColor(task.isCompleted ? .gray : .black)

                            Spacer()

                            Button(action: {
                                taskList.toggleCompletion(for: task)
                            }) {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(task.isCompleted ? .green : .gray)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .onDelete(perform: taskList.removeTasks)
                }
            }
            .navigationTitle("To-Do List")
            .navigationBarItems(trailing: EditButton())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
