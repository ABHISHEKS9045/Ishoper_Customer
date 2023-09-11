class SupportTicketBody {
  String _type;
  String _subject;
  String _description;
  String _amount;
  // String  _WalletWithdrawal;

  SupportTicketBody(String type, String subject, String description,String amount) {
    this._type = type;
    this._subject = subject;
    this._description = description;
    this._amount = amount;
    // this._WalletWithdrawal = WalletWithdrawal;
  }

  String get type => _type;
  String get subject => _subject;
  String get description => _description;
  String get amount => _amount;
  // String get WalletWithdrawal => _WalletWithdrawal;

  SupportTicketBody.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    _subject = json['subject'];
    _description = json['description'];
    _amount = json['wallet_amount'];
    // _WalletWithdrawal = json['wallet_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this._type;
    data['subject'] = this._subject;
    data['description'] = this._description;
    data['amount'] = this._amount;
    return data;
  }
}
