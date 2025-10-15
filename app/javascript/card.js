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

    // 既存のエラー表示を削除
    const existingErrorBox = document.querySelector('.error-alert');
    if (existingErrorBox) existingErrorBox.remove();

    // 配送先のバリデーションチェック
    const shippingErrors = [];
    const postalCode = document.getElementById('postal-code').value.trim();
    const prefecture = document.getElementById('prefecture').value;
    const city = document.getElementById('city').value.trim();
    const address = document.getElementById('addresses').value.trim();
    const phoneNumber = document.getElementById('phone-number').value.trim();

    if (!postalCode) shippingErrors.push("Postal code can't be blank");
    else if (!/^\d{3}-\d{4}$/.test(postalCode)) shippingErrors.push("Postal code is invalid. Enter it as follows (e.g. 123-4567)");

    if (!prefecture || prefecture === "0") shippingErrors.push("Prefecture can't be blank");
    if (!city) shippingErrors.push("City can't be blank");
    if (!address) shippingErrors.push("Addresses can't be blank");

    if (!phoneNumber) shippingErrors.push("Phone number can't be blank");
    else if (!/^\d{10,11}$/.test(phoneNumber)) {
      if (phoneNumber.length < 10) shippingErrors.push("Phone number is too short");
      else shippingErrors.push("Phone number is invalid. Input only number");
    }

    // 配送先のエラーがあれば表示
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
      return; // カード処理に進まない
    }

    // カードトークン作成
    payjp.createToken(numberElement).then((response) => {
      const errorContainer = document.createElement('div');
      errorContainer.classList.add('error-alert');
      const errorList = document.createElement('ul');

      if (response.error) {
        // トークン生成エラー
        const li = document.createElement('li');
        li.classList.add('error-message');
        li.innerText = "Token can't be blank";
        errorList.appendChild(li);
        errorContainer.appendChild(errorList);
        form.prepend(errorContainer);
      } else if (!response.id) {
        // 念のためトークン未生成時も同様に
        const li = document.createElement('li');
        li.classList.add('error-message');
        li.innerText = "Token can't be blank";
        errorList.appendChild(li);
        errorContainer.appendChild(errorList);
        form.prepend(errorContainer);
      } else {
        // エラーがなければ送信
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
