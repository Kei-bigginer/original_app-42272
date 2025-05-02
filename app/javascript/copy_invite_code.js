// app/javascript/copy_invite_code.js

// ✅ DOMの読み込みが完了したタイミングで発火する
document.addEventListener("DOMContentLoaded", () => {
  // ✅ 各HTML要素を取得
  const copyBtn = document.getElementById("copy-btn");       // 「コピー」ボタン
  const inviteCode = document.getElementById("invite-code"); // 表示中の招待コード
  const message = document.getElementById("copy-message");   // コピー成功メッセージ欄

  // ✅ 要素がすべて存在する時だけ実行（念のためのガード）
  if (copyBtn && inviteCode && message) {
    copyBtn.addEventListener("click", () => {
      // ✅ クリップボードAPIを使って、招待コードの文字をコピー
      navigator.clipboard.writeText(inviteCode.textContent).then(() => {
        // ✅ コピー成功時、「コピーしました」メッセージを表示
        message.style.display = "block";

        // ✅ 3秒後にメッセージを自動で非表示にする
        setTimeout(() => {
          message.style.display = "none";
        }, 3000);
      });
    });
  }
});
