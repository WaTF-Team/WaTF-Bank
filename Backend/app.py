from flask_sqlalchemy import SQLAlchemy
from random import *
import os
import json
from models import *
import sqlite3

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///app.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
db = SQLAlchemy(app)

@app.route('/')
def hello():
    return "welcome" + " : " + "hello"

@app.route('/login', methods=['POST'])
def login():
    data = json.dumps(request.json)
    request_body_Json = json.loads(data)
    username = request_body_Json['username']
    password = request_body_Json['password']
    u = User.query.filter_by(username = username).first()
    if not u:
        return '{"message":"Invalid username"}'
    else:
        if u.password != password:
            return '{"message":"Invalid username or password"}'
        accountNoDB = u.accountNo
        token = str(randint(0000000000, 9999999999))
        db.session.add(LoginLog(user_id = u.id))
        u.token = token
        db.session.merge(u)
        db.session.commit()
        db.session.close_all()
        return '{"message":"Success", "accountNo":"' + accountNoDB + '", "token":"' + token  + '"}'

@app.route('/checkAuthen')
def checkAuthen():
    token = request.headers.get('token')
    u = User.query.filter_by(token = token).first()
    if not u or not token:
        return '{"message":"Invalid token"}'
    else:
        return '{"message":"Success"}'

@app.route('/accountSummary', methods=['POST'])
def accountSummary():
    data = json.dumps(request.json)
    request_body_Json = json.loads(data)
    accountNo = request_body_Json['accountNo']
    token = request_body_Json['token']
    u = User.query.filter_by(token = token).first()
    v = User.query.filter_by(accountNo = accountNo).first()
    if not u or not token:
        return '{"message":"Invalid token"}'
    elif not v:
        return '{"message":"Invalid account Number"}'
    return '{"message":"Success", "username":"' + v.username + '", "accountNo":"' + v.accountNo   + '", "tel":"' + v.tel  + '", "balance":"' + v.balance  + '", "citizenID":"' + v.citizenID + '"}'

@app.route('/transfer', methods=['POST'])
def transfer():
    data = json.dumps(request.json)
    request_body_Json = json.loads(data)
    accountNo = request_body_Json['accountNo']
    toAccountNo = request_body_Json['toAccountNo']
    amount = request_body_Json['amount']
    token = request_body_Json['token']
    u = User.query.filter_by(token = token).first()
    a = User.query.filter_by(accountNo = accountNo).first()
    b = User.query.filter_by(accountNo = toAccountNo).first()
    if not u or not token:
        return '{"message":"Invalid token"}'
    elif not a or not b:
        return '{"message":"Invalid Account Number"}'
    else:
        try:
            amountInt = int(amount)
        except ValueError:
            return '{"message":"Amount must be Integer"}'
        if int(a.balance) - amountInt < 0:
            return '{"message":"Do not have enough money"}'
        else:
            tel = b.tel
            toAccount = b.accountNo
            username = a.username
            amount = str(amountInt)
            a.balance = str(int(a.balance) - amountInt)
            b.balance = str(int(b.balance) + amountInt)
            id = a.id
            db.session.merge(u)
            db.session.add(TransferHistory(account = accountNo, to_account = toAccountNo, amount = amount, user_id = id))
            db.session.commit()
            db.session.close_all()
            return '{"message":"Success", "tel":"' + tel + '", "amount":"' + amount + '", "toAccount":"' + toAccount + '", "username":"' + username + '"}'

@app.route('/transferHistory', methods=['POST'])
def transferHistory():
    data = json.dumps(request.json)
    request_body_Json = json.loads(data)
    accountNo = request_body_Json['accountNo']
    token = request_body_Json['token']
    u = User.query.filter_by(token = token).first()
    if not u or not token:
        return '{"message":"Invalid token"}'
    else:
        a = '{"message":"Success", "transaction":['
        conn = sqlite3.connect('app.db')
        transfer_historys = conn.execute("select * from transfer_historys where account = '" + str(accountNo) + "';")
        for transfer_history in transfer_historys:
            a += '{"accountNo":"' + str(transfer_history[1]) +'", "toAccountNo":"' + str(transfer_history[2]) + '", "amount":"' + str(transfer_history[3]) + '", "datetime":"' + datetime.strptime(transfer_history[4], "%Y-%m-%d %H:%M:%S.%f").strftime("%d-%m-%y %H:%M") + '"},'
        return a + ']}'

@app.route('/UsersLoginLog')
def LoginUserLog():
    login_logs = LoginLog.query.all()
    return render_template('login_user_log.html', login_logs=login_logs)

if __name__ == '__main__':
    app.run(host= '0.0.0.0', port=5000, debug=False, ssl_context=('cert.pem', 'key.pem'))
