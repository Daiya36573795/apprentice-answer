#!/bin/bash

# 保存先ファイル
FILE="passwords.txt"
ENCRYPTED_FILE="passwords.txt.gpg"

# パスフレーズ
PASSPHRASE="encryption-password"

# パスワードマネージャーのメッセージを表示
echo "パスワードマネージャーへようこそ！"

# パスワードを保存する関数
add_password() {
    read -p "サービス名を入力してください: " service_name
    read -p "ユーザー名を入力してください: " username
    read -sp "パスワードを入力してください: " password
    echo ""  # パスワード入力後に改行を挿入

    # 暗号化ファイルが存在する場合は復号して内容を取得
    if [ -f "$ENCRYPTED_FILE" ]; then
        gpg --decrypt --batch --yes --passphrase "$PASSPHRASE" --output "$FILE" "$ENCRYPTED_FILE"
    fi

    # 新しい情報をファイルに追記
    echo "$service_name:$username:$password" >> "$FILE"

    # ファイルを暗号化
    gpg --symmetric --batch --yes --passphrase "$PASSPHRASE" "$FILE"

    # 暗号化後に元ファイルを削除
    rm "$FILE"

    echo "パスワードの追加は成功しました。"
}

# パスワードを取得する関数
get_password() {
    read -p "サービス名を入力してください: " service_name

    # ファイルが存在する場合のみ復号化
    if [ -f "$ENCRYPTED_FILE" ]; then
        gpg --decrypt --batch --yes --passphrase "$PASSPHRASE" --output "$FILE" "$ENCRYPTED_FILE"
    else
        echo "暗号化ファイルが存在しません。"
        return
    fi

    # サービス名で検索
    result=$(grep "^$service_name:" "$FILE")
    if [ -z "$result" ]; then
        echo "そのサービスは登録されていません。"
    else
        # サービス情報を表示
        IFS=":" read -r stored_service_name stored_username stored_password <<< "$result"
        echo "サービス名：$stored_service_name"
        echo "ユーザー名：$stored_username"
        echo "パスワード：$stored_password"
    fi

    # 復号化後に元のファイルを削除
    rm "$FILE"
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
