from app import db
from datetime import datetime, timedelta

class User(db.Model):
    __tablename__ = 'users'
    transfer_historys = db.relationship('TransferHistory', backref='users')
    login_logs = db.relationship('LoginLog', backref='users')

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), nullable=False, unique=True)
    password = db.Column(db.String(20), nullable=False)
    accountNo = db.Column(db.String(10), nullable=False, unique=True)
    balance = db.Column(db.String(20), nullable=False)
    tel = db.Column(db.String(20), nullable=False)
    token = db.Column(db.String(20))
    citizenID = db.Column(db.String(13))

    def __repr__(self):
        return '<id {}>'.format(self.id)

class TransferHistory(db.Model):
    __tablename__ = 'transfer_historys'

    id = db.Column(db.Integer, primary_key=True)
    account = db.Column(db.String(10))
    to_account = db.Column(db.String(10))
    amount = db.Column(db.String(10))
    datetime = db.Column(db.DateTime, default=datetime.now())
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    def __repr__(self):
        return '<id {}>'.format(self.id)

class LoginLog(db.Model):
    __tablename__ = 'login_logs'

    id = db.Column(db.Integer, primary_key=True)
    datetime = db.Column(db.DateTime, default=datetime.now())
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    def __repr__(self):
        return '<id {}>'.format(self.id)

class TokenCount(db.Model):
    __tablename__ = 'token_counts'

    id = db.Column(db.Integer, primary_key=True)
    token_count = db.Column(db.Integer, nullable=False)

    def __repr__(self):
        return '<id {}>'.format(self.id)
