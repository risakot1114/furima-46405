const pay = () => {
  const payjp = Payjp('pk_test_b1a545ffe649b68ccacd022e'); // テスト公開鍵
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
      if (response.error) {
    
        alert(`カード情報にエラーがあります: ${response.error.message}`);
      } else {
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
