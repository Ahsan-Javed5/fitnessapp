class MessageType {
  // Thread Type
  ///old messages Types
  static const int TextV1 = 0;
  static const int VideoV1 = 2;
  // static const int Audio = 1;
  // static const int Image = 4;
  ///new messages Types
  static const int Text = 1;
  static const int Audio = 2;
  static const int Image = 3;
  static const int Video = 4;
  static const int Document = 5;

  ///for handling old and newChat
  ///if the type inside the message is not [Message.type] != -1  then the message will be from old chat apk
  ///else if [Message.type] == -1 then the message is from new chat apk
  static const int ChatMessageHandler = -1;
}
