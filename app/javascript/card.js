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

    // 既存のエラー表示をクリア
    const existingErrorBox = document.querySelector('.error-alert');
    if (existingErrorBox) {
      existingErrorBox.remove();
    }

    // 配送先のバリデーションチェック
    const shippingErrors = [];
    const postalCode = document.getElementById('postal-code').value.trim();
    const city = document.getElementById('city').value.trim();
    const address = document.getElementById('addresses').value.trim();
    const phoneNumber = document.getElementById('phone-number').value.trim();

    if (!postalCode) shippingErrors.push('Postal code is required.');
    if (!city) shippingErrors.push('City is required.');
    if (!address) shippingErrors.push('Address is required.');
    if (!phoneNumber) shippingErrors.push('Phone number is required.');

    // 配送先エラーがあれば表示
    if (shippingErrors.length > 0) {
      const errorContainer = document.createElement('div');
      errorContainer.classList.add('error-alert');
      const errorList = document.createElement('ul');

      shippingErrors.forEach(msg => {
        const li = document.createElement('li');
        li.classList.add('error-message');
        li.innerText = msg;
        errorList.appendChild(li);
      });

      errorContainer.appendChild(errorList);
      form.prepend(errorContainer);
      return; // カード処理はせずに終了
    }

    // カード情報のトークン作成
    payjp.createToken(numberElement).then((response) => {
      if (response.error) {
        const errorContainer = document.createElement('div');
        errorContainer.classList.add('error-alert');
        const errorList = document.createElement('ul');
        const li = document.createElement('li');
        li.classList.add('error-message');
        li.innerText = `Card error: ${response.error.message}`;
        errorList.appendChild(li);
        errorContainer.appendChild(errorList);
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
