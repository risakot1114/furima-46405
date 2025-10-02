const initializePriceFields = () => {
  const priceInput = document.getElementById('item-price');
  const feeDisplay = document.getElementById('add-tax-price'); 
  const profitDisplay = document.getElementById('profit');     

  if (!priceInput) return;

  priceInput.addEventListener('input', () => {
    let value = priceInput.value;

    value = value.replace(/[^\d]/g, '');
    priceInput.value = value;

    const price = parseInt(value, 10);

    if (!isNaN(price) && price >= 300 && price <= 9999999) {
      const fee = Math.floor(price * 0.1);      
      const profit = Math.floor(price - fee);  

      feeDisplay.textContent = fee.toLocaleString();
      profitDisplay.textContent = profit.toLocaleString();
    } else {
      feeDisplay.textContent = '-';
      profitDisplay.textContent = '-';
    }
  });
};

document.addEventListener('turbo:load', initializePriceFields);
document.addEventListener('turbo:render', initializePriceFields);
