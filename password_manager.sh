#!/bin/bash

# 保存先ファイルを指定
FILE="passwords.txt"

# パスワードを保存する関数
add_password() {
    read -p "サービス名を入力してください: " service_name
    read -p "ユーザー名を入力してください: " username
    read -sp "パスワードを入力してください: " password
    echo # 改行
    # 情報をファイルに保存
    echo "$service_name:$username:$password" >> $FILE
    echo "パスワードの追加は成功しました。"
}

# パスワードを取得する関数
get_password() {
    read -p "サービス名を入力してください: " service_name
    # 指定されたサービス名がファイルにあるか検索
    result=$(grep "^$service_name:" $FILE)
    if [ -z "$result" ]; then
        echo "そのサービスは登録されていません。"
    else
        # サービス情報を表示
        IFS=":" read -r stored_service_name stored_username stored_password <<< "$result"
        echo "サービス名：$stored_service_name"
        echo "ユーザー名：$stored_username"
        echo "パスワード：$stored_password"
    fi
}

# メインループ
while true; do
    echo "パスワードマネージャーへようこそ！"
    read -p "次の選択肢から入力してください(Add Password/Get Password/Exit)：" action

    case "$action" in
        "Add Password")
            add_password
            ;;
        "Get Password")
            get_password
            ;;
        "Exit")
            echo "Thank you!"
            exit 0
            ;;
        *)
            echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
            ;;
    esac
done
