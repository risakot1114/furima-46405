const pay = () => {
  const publicKey = (typeof gon !== 'undefined' && gon.public_key) ? gon.public_key : '';
  if (!publicKey) return; 
  const payjp = Payjp(publicKey);
  const elements = payjp.elements();

  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');

  numberElement.mount('#number-form');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');

  const form = document.getElementById('charge-form');

form.addEventListener("submit", (e) => {
  e.preventDefault();

  payjp.createToken(numberElement).then((response) => {
    // まず既存のエラー表示をクリア
    const errorBox = document.querySelector('.error-alert');
    if (errorBox) {
      errorBox.innerHTML = '';
    }

    if (response.error) {
      // エラー表示用 div を作成
      const errorContainer = document.createElement('div');
      errorContainer.classList.add('error-alert');

      const errorList = document.createElement('ul');
      const errorItem = document.createElement('li');
      errorItem.classList.add('error-message');
      errorItem.innerText = `カード情報にエラーがあります: ${response.error.message}`;

      errorList.appendChild(errorItem);
      errorContainer.appendChild(errorList);

      // フォームの先頭に表示
      form.prepend(errorContainer);

    } else {
      // エラーなしの場合はフォーム送信
      const token = response.id;
      const tokenInput = document.createElement("input");
      tokenInput.setAttribute("type", "hidden");
      tokenInput.setAttribute("name", "order_address[token]");
      tokenInput.setAttribute("value", token);
      form.appendChild(tokenInput);
      form.submit();
    }

    numberElement.clear();
    expiryElement.clear();
    cvcElement.clear();
  });
});
};

window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);
