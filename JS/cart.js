let listings = [
	{ brand: "Nike", description: "Dunk Low Premium", price: 10.0, size: 4390 },
	{
		brand: "Nike",
		description: "Air Force One Low EVO",
		price: 20.0,
		size: 473,
	},
	{ brand: "Nike", description: "JumpMan MVP3", price: 30.0, size: 493 },
	{ brand: "Nike", description: "GORE-TEX Cortez TXT", price: 30.0, size: 949 },
];

const cartItems = [
	// { brand: "Nike", description: "Dunk Low Premium", price: 10.0, size: 43 },
	// {
	// 	brand: "Nike",
	// 	description: "Air Force One Low EVO",
	// 	price: 20.0,
	// 	size: 43,
	// },
	// { brand: "Nike", description: "JumpMan MVP3", price: 30.0, size: 43 },
	// { brand: "Nike", description: "GORE-TEX Cortez TXT", price: 30.0, size: 43 },
];

// Save the array to localStorage
localStorage.setItem("cartItems", JSON.stringify(cartItems));
localStorage.setItem("listings", JSON.stringify(listings));

// Retrieve the cart from localStorage
const cartItemsString = localStorage.getItem("cartItems");
const retrievedCartItems = cartItemsString ? JSON.parse(cartItemsString) : [];

// document.getElementById("cartItemsCount").innerHTML = cartItemsCount;
// // Save the updated cart back to localStorage
// localStorage.setItem('cartItems', JSON.stringify(cart));

function addItemToCart(item) {
	cartItems.push(item);
	updateCart();
}

function removeItemFromCart(index) {
	cartItems.splice(index, 1);
	updateCart();
}

function updateCart() {
	const cartContainer = document.getElementById("cart-container");
	cartContainer.innerHTML = "<p> NO ITEMS YET </p>";
	let totalPrice = 0;
	let cartCount = 0;

	cartItems.forEach((item, index) => {
		const cartItem = document.createElement("div");
		cartItem.className = "cart-item";
		cartItem.innerHTML = `
   <div class="pro-container">
        <div class="product">
          <img src="images/men product/shoe7.png" />
          <div class="desc">
            <span>${item.brand}</span>
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
		//     itemElement.innerHTML = `
		// 	<div class="product">
		//       <img src="images/men product/shoe7.png"/>
		//       <div class="desc" id="button">
		//         <span>${item.brand}</span>
		//         <h5>${item.description}</h5>
		//         <h6>Men's Shoe - UK ${item.size}</h6>
		//         <h4>GHS : ${item.price.toFixed(2)}</h4>
		//       </div>
		//    </div>
		// `;

		const button = document.createElement("button");
		button.textContent = "Add to Cart";
		button.setAttribute("data-item", JSON.stringify(item));
		button.addEventListener("click", function () {
			addItemToCart(JSON.parse(this.getAttribute("data-item")));
		});

		itemElement.appendChild(button);
		itemsContainer.appendChild(itemElement);
		// localStorage.setItem('cartItems', JSON.stringify(cart));
	});

	// Retrieve the cart from localStorage and display it
	//   const cart = JSON.parse(localStorage.getItem('listings')) || [];

	// retrievedCartItems.forEach((item) => {
	// 	const itemElement = document.createElement("div");
	// 	// itemElement.setAttribute("id", "uniqueId");
	// 	itemElement.innerHTML = `
	//     <div class="product">
	//       <img src="images/men product/shoe7.png"/>
	//       <div class="desc">
	//         <span>${item.brand}</span>
	//         <h5>${item.description}</h5>
	//         <h6>Men's Shoe - UK ${item.size}</h6>
	//         <h4>GHS : ${item.price.toFixed(2)}</h4>
	//       </div>
	//       <button onclick="addItemToCart(${JSON.stringify(item)})">Add to Cart</button>
	//    </div>
	// `;
	// 	itemsContainer.appendChild(itemElement);
	// });
}

displayItems();
updateCart();
