let listings = [
  { image: "images/men product/shoe14.png", brand: "Nike", description: "Dunk Low Premium", price: 4390.0, size: 43 },
  {
    image: "images/men product/shoe7.png",
    brand: "Nike",
    description: "Air Force One Low EVO",
    price: 20.0,
    size: 473,
  },
  { image: "images/men product/shoe12.png", brand: "Nike", description: "JumpMan MVP3", price: 3780.0, size: 43 },
  { image: "images/men product/shoe10.png", brand: "Nike", description: "GORE-TEX Cortez TXT", price: 3780.0, size: 49 },
];
localStorage.setItem("listings", JSON.stringify(listings));

const cartItems = [];

if (!localStorage.getItem("cartItems")) {
  localStorage.setItem("cartItems", JSON.stringify(cartItems));
}

// Retrieve the current cart from localStorage
const cart = JSON.parse(localStorage.getItem("cartItems")) || [];
console.log(cart);

function addItemToCart(item) {
  // Add the new item to the cart
  cart.push(item);
  // Save the updated cart back to localStorage
  localStorage.setItem("cartItems", JSON.stringify(cart));
  updateCart();
}

function removeItemFromCart(index) {
  cart.splice(index, 1);
  // Save the updated cart back to localStorage
  localStorage.setItem("cartItems", JSON.stringify(cart));
  updateCart();
}

function updateCart() {
  const cartContainer = document.getElementById("cart-container");
  cartContainer.innerHTML = "<p> NO ITEMS YET </p>";
  let totalPrice = 0;
  let cartCount = 0;

  cart.forEach((item, index) => {
    const cartItem = document.createElement("div");
    cartItem.className = "cart-item";
    cartItem.innerHTML = `
    <div class="pro-container">
         <div class="product">
           <img src="${item.image}"/>
           <div class="desc">
             <h3>${item.brand}</h3>
             <h5>${item.description}</h5>
             <h6>Men's Shoe - UK ${item.size}</h6>
             <h4>GHS : ${item.price.toFixed(2)}</h4>
           </div>
           <button onclick="removeItemFromCart(${index})">Remove from Cart</button>
     </div>
        `;
    cartContainer.appendChild(cartItem);
    totalPrice += item.price;
    cartCount += 1;
  });

  document.getElementById("total-price").innerText = totalPrice;
  document.getElementById("cartItemsCount").innerHTML = cartCount;
}

function displayItems() {
  const itemsContainer = document.getElementById("items-container");
  itemsContainer.innerHTML = "New Listings";

  listings.forEach((item, index) => {
    const itemElement = document.createElement("div");
    itemElement.textContent = `${item.brand}: ${item.description} - $${item.price}`;

    const button = document.createElement("button");
    button.textContent = "Add to Cart";
    button.setAttribute("data-item", JSON.stringify(item));
    button.addEventListener("click", function() {
      addItemToCart(JSON.parse(this.getAttribute("data-item")));
    });

    itemElement.appendChild(button);
    itemsContainer.appendChild(itemElement);
  }

function displayCart() {
      const itemsContainer = document.getElementById("cart-container");
      itemsContainer.innerHTML = "Cart";

      cart.forEach((item, index) => {
        const itemElement = document.createElement("div");
        itemElement.textContent = `${item.brand}: ${item.description} - $${item.price}`;

        const button = document.createElement("button");
        button.textContent = "Remote From Cart";
        button.setAttribute("data-item", JSON.stringify(item));
        button.addEventListener("click", function() {
          removeItemFromCart(index);
        });

        itemElement.appendChild(button);
        itemsContainer.appendChild(itemElement);

      };

      displayItems();
      displayCart();
