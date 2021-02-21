構成を一新しました。このリポジトリは旧Biotterのコードとなります。(2021/02/21)

新リポジトリ: https://github.com/tetetratra/biotter-rails

---

# Biotter

ツイッターのプロフィール欄の編集履歴を記録します

http://biotter.tetetratra.net

## 実行方法
`bundle exec pumactl start`

## 環境変数
```
BIOTTER_CONSUMER_KEY
BIOTTER_CONSUMER_SECRET
BIOTTER_ACCESS_TOKEN
BIOTTER_ACCESS_TOKEN_SECRET
```

## cron設定

```
0,10,20,30,40,50 * * * * cd ~/biotter; /bin/bash -l -c 'bundle exec ruby exec.rb'
```

