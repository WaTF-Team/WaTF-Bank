import os
from flask_script import Manager
from flask_migrate import Migrate, MigrateCommand
import random
from datetime import datetime, timedelta
from models import *
from app import app, db

migrate = Migrate(app, db)
manager = Manager(app)
manager.add_command('db', MigrateCommand)

@manager.command
def initdb():
    db.session.add(User(username="michael", password="michael123", accountNo="1111111111", balance="50000", tel="0811111111", citizenID="4344467150234"))
    db.session.add(User(username="william", password="william123", accountNo="2222222222", balance="100000", tel="0822222222", citizenID="2024867420812"))
    db.session.add(User(username="emma", password="emma123", accountNo="3333333333", balance="1500000", tel="0833333333", citizenID="1542887628074"))
    db.session.add(User(username="jacob", password="jacob123", accountNo="4444444444", balance="200000", tel="0844444444", citizenID="5861159789693"))
    db.session.commit()

    db.session.add(TransferHistory(account="1111111111" ,to_account="2222222222", amount="1000", datetime = datetime.now() - timedelta(days = 30) - timedelta(minutes = random.randint(1350,1400)),user_id=1))
    db.session.add(TransferHistory(account="3333333333" ,to_account="2222222222", amount="1400", datetime = datetime.now() - timedelta(days = 29) - timedelta(minutes = random.randint(500,550)), user_id=3))
    db.session.add(TransferHistory(account="1111111111" ,to_account="3333333333", amount="1100", datetime = datetime.now() - timedelta(days = 17) - timedelta(minutes = random.randint(100,150)), user_id=1))
    db.session.add(TransferHistory(account="2222222222" ,to_account="3333333333", amount="1110", datetime = datetime.now() - timedelta(days = 26) - timedelta(minutes = random.randint(1350,1400)), user_id=2))
    db.session.add(TransferHistory(account="2222222222" ,to_account="4444444444", amount="1600", datetime = datetime.now() - timedelta(days = 20) - timedelta(minutes = random.randint(100,150)), user_id=2))
    db.session.add(TransferHistory(account="4444444444" ,to_account="1111111111", amount="1200", datetime = datetime.now() - timedelta(days = 15) - timedelta(minutes = random.randint(500,550)), user_id=4))
    db.session.add(TransferHistory(account="4444444444" ,to_account="2222222222", amount="1100", datetime = datetime.now() - timedelta(days = 12) - timedelta(minutes = random.randint(100,150)), user_id=4))
    db.session.add(TransferHistory(account="2222222222" ,to_account="3333333333", amount="1500", datetime = datetime.now() - timedelta(days = 10) - timedelta(minutes = random.randint(500,550)), user_id=2))
    db.session.add(TransferHistory(account="4444444444" ,to_account="1111111111", amount="100", datetime = datetime.now() - timedelta(days = 8) - timedelta(minutes = random.randint(1350,1400)), user_id=4))
    db.session.add(TransferHistory(account="1111111111" ,to_account="2222222222", amount="120", datetime = datetime.now() - timedelta(days = 5) - timedelta(minutes = random.randint(500,550)), user_id=1))
    db.session.add(TransferHistory(account="3333333333" ,to_account="4444444444", amount="15000", datetime = datetime.now() - timedelta(days = 3) - timedelta(minutes = random.randint(1350,1400)), user_id=3))
    db.session.add(TransferHistory(account="1111111111" ,to_account="2222222222", amount="1300", datetime = datetime.now() - timedelta(days = 3) - timedelta(minutes = random.randint(500,550)), user_id=1))
    db.session.add(TransferHistory(account="2222222222" ,to_account="1111111111", amount="1900", datetime = datetime.now() - timedelta(days = 2) - timedelta(minutes = random.randint(1350,1400)), user_id=2))
    db.session.add(TransferHistory(account="3333333333" ,to_account="1111111111", amount="13400", datetime = datetime.now() - timedelta(days = 2) - timedelta(minutes = random.randint(100,150)), user_id=3))
    db.session.add(TransferHistory(account="2222222222" ,to_account="3333333333", amount="1200", datetime = datetime.now() - timedelta(days = 1) - timedelta(minutes = random.randint(100,150)), user_id=2))
    db.session.commit()

    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 30) - timedelta(minutes = random.randint(1400,1425)), user_id=1))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 29) - timedelta(minutes = random.randint(550,575)), user_id=3))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 28) - timedelta(minutes = random.randint(0,1400)), user_id=random.randint(1,4)))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 26) - timedelta(minutes = random.randint(1400,1425)), user_id=2))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 26) - timedelta(minutes = random.randint(0,1390)), user_id=random.randint(1,4)))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 25) - timedelta(minutes = random.randint(0,1400)), user_id=random.randint(1,4)))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 24) - timedelta(minutes = random.randint(0,1400)), user_id=random.randint(1,4)))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 20) - timedelta(minutes = random.randint(75,100)), user_id=2))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 19) - timedelta(minutes = random.randint(150,175)), user_id=1))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 17) - timedelta(minutes = random.randint(0,1400)), user_id=random.randint(1,4)))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 15) - timedelta(minutes = random.randint(550,575)), user_id=4))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 14) - timedelta(minutes = random.randint(0,1400)), user_id=random.randint(1,4)))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 13) - timedelta(minutes = random.randint(0,1400)), user_id=random.randint(1,4)))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 12) - timedelta(minutes = random.randint(150,175)), user_id=4))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 10) - timedelta(minutes = random.randint(550,575)), user_id=2))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 9) - timedelta(minutes = random.randint(0,1400)), user_id=random.randint(1,4)))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 8) - timedelta(minutes = random.randint(1400,1425)), user_id=4))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 7) - timedelta(minutes = random.randint(0,1400)), user_id=random.randint(1,4)))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 6) - timedelta(minutes = random.randint(0,1400)), user_id=random.randint(1,4)))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 5) - timedelta(minutes = random.randint(550,575)), user_id=1))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 5) - timedelta(minutes = random.randint(0,500)), user_id=1))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 4) - timedelta(minutes = random.randint(0,1400)), user_id=random.randint(1,4)))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 3) - timedelta(minutes = random.randint(1400,1425)), user_id=3))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 3) - timedelta(minutes = random.randint(550,575)), user_id=1))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 2) - timedelta(minutes = random.randint(1400,1425)), user_id=2))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 2) - timedelta(minutes = random.randint(150,175)), user_id=3))
    db.session.add(LoginLog(datetime = datetime.now() - timedelta(days = 1) - timedelta(minutes = random.randint(150,175)), user_id=2))
    db.session.commit()
    print('initial database success')

if __name__ == '__main__':
    manager.run()
