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
      const errorBox = document.getElementById('card-error'); // ← 追加！

      if (response.error) {
        errorBox.innerText = `カード情報にエラーがあります: ${response.error.message}`;
        errorBox.style.display = 'block';
      } else {
        errorBox.style.display = 'none'; // 前のエラー消す
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
