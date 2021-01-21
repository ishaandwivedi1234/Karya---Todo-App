class Task {
  // 'taskTitle': 'complete python notes',
  //   'taskDescription': 'complete notes of python before exam',
  //   'status': 'pending',
  //   'userId': 0
  String taskTitle;
  String taskDescription;
  String status;
  String userId;
  String taskId;

  Task(
      {this.taskId,
      this.taskTitle,
      this.taskDescription,
      this.status,
      this.userId});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        taskId: json["_id"],
        taskTitle: json['taskTitle'],
        taskDescription: json['taskDescription'],
        status: json['status'],
        userId: json['userId']);
  }
}
