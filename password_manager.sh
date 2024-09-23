!/bin/bash

# ファイルの保存先を指定
FILE="passwords.txt"

# パスワードマネージャーのメッセージを表示
echo "パスワードマネージャーへようこそ！"

# 入力を促す
read -p "サービス名を入力してください: " service_name
read -p "ユーザー名を入力してください: " username
read -sp "パスワードを入力してください: " password
echo # パスワード入力後改行

# 情報をファイルに追記
echo "$service_name:$username:$password" >> $FILE

# 完了メッセージを表示
echo "Thank you!"
