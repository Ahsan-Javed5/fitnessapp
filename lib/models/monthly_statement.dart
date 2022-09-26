class MonthlyStatement {
  String? lastStatementDate;
  String? statementPdf;
  int? totalSubscribers;
  String? amount;
  String? createdAt;
  String? updatedAt;

  MonthlyStatement({
    this.lastStatementDate,
    this.statementPdf,
    this.totalSubscribers,
    this.amount,
    this.createdAt,
    this.updatedAt,
  });

  MonthlyStatement.fromJson(Map<String, dynamic> json) {
    lastStatementDate = json['last_statement_date']?.toString();
    statementPdf = json['statement_pdf']?.toString();
    totalSubscribers = json['total_subscribers']?.toInt();
    amount = json['amount']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }
}
