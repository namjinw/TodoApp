package com.example.dart_my.model

// 나중에 확장될 수 있으니 객체로 만들어 놓음
class TodoModel(
    val id: String,
    val title: String,
    val content: String
) {
    // 클래스 공통 로직
    // Flutter에서 받은 Map 정보를 파싱해 객체로 전달
    companion object {
        fun parseTodo(todo: Map<String, Any>): TodoModel {
            return TodoModel(
                id = todo["id"].toString(),
                title = todo["title"].toString(),
                content = todo["content"].toString()
            )
        }
    }
}
