<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Swadisht | Online Food Ordering</title>
<meta name="description" content="Discover delicious food at Swadisht. Explore our menu, place an order and track your food order online.">

<style>
:root {
    --primary: #e65324;
    --primary-dark: #bd3815;
    --dark: #28221f;
    --text: #51463f;
    --muted: #82756d;
    --background: #fffaf5;
    --white: #ffffff;
    --border: #f0e7df;
    --green: #18864b;
    --shadow: 0 12px 35px rgba(45, 30, 20, 0.08);
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

html {
    scroll-behavior: smooth;
    scroll-padding-top: 100px;
}

body {
    font-family: "Segoe UI", Arial, sans-serif;
    background: var(--background);
    color: var(--dark);
    line-height: 1.6;
}

a {
    color: inherit;
}

a:focus-visible {
    outline: 3px solid var(--primary);
    outline-offset: 4px;
}

.container {
    width: min(1120px, 86%);
    margin: auto;
}

/* HEADER */

header {
    position: sticky;
    top: 0;
    z-index: 100;
    background: rgba(255, 255, 255, 0.97);
    border-bottom: 1px solid var(--border);
    box-shadow: 0 4px 20px rgba(40, 34, 31, 0.04);
}

.navbar {
    width: min(1200px, 90%);
    min-height: 78px;
    margin: auto;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 22px;
}

.logo {
    text-decoration: none;
    display: flex;
    align-items: center;
    gap: 10px;
    color: var(--primary);
    font-size: 26px;
    font-weight: 800;
    letter-spacing: -0.7px;
    white-space: nowrap;
}

.logo-icon {
    width: 43px;
    height: 43px;
    display: grid;
    place-items: center;
    background: #fff0e5;
    border-radius: 13px;
    font-size: 24px;
}

nav {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    justify-content: center;
    gap: 24px;
}

nav a {
    text-decoration: none;
    font-size: 14px;
    font-weight: 650;
    color: var(--text);
    transition: color 0.2s;
}

nav a:hover {
    color: var(--primary);
}

nav .nav-cta {
    color: var(--white);
    background: var(--primary);
    padding: 11px 17px;
    border-radius: 9px;
}

nav .nav-cta:hover {
    color: var(--white);
    background: var(--primary-dark);
}

/* BUTTONS */

.btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    min-height: 48px;
    padding: 13px 21px;
    border: 1px solid transparent;
    border-radius: 10px;
    background: var(--primary);
    color: var(--white);
    font-size: 14px;
    font-weight: 700;
    text-decoration: none;
    cursor: pointer;
    transition: background 0.2s, transform 0.2s;
}

.btn:hover {
    background: var(--primary-dark);
    transform: translateY(-2px);
}

.btn-outline {
    color: var(--dark);
    background: var(--white);
    border-color: var(--border);
}

.btn-outline:hover {
    background: #fff0e5;
    color: var(--primary-dark);
    border-color: #f5c4aa;
}

/* HERO */

.hero {
    position: relative;
    overflow: hidden;
    background:
        radial-gradient(circle at 85% 12%, #ffd8b9 0, transparent 30%),
        linear-gradient(120deg, #fff4e9 0%, #fffaf5 65%, #ffecdc 100%);
    padding: 72px 0;
}

.hero-inner {
    display: grid;
    grid-template-columns: 1.05fr 0.95fr;
    align-items: center;
    gap: 58px;
}

.eyebrow {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 20px;
    padding: 8px 13px;
    border: 1px solid #f5d6c3;
    border-radius: 30px;
    background: rgba(255, 255, 255, 0.75);
    color: var(--primary-dark);
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 1.1px;
}

.hero h1 {
    max-width: 620px;
    margin-bottom: 22px;
    font-size: clamp(42px, 5.4vw, 68px);
    line-height: 1.09;
    letter-spacing: -2.2px;
}

.hero h1 span {
    color: var(--primary);
}

.hero-description {
    max-width: 510px;
    margin-bottom: 29px;
    color: var(--muted);
    font-size: 16px;
    line-height: 1.9;
}

.hero-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 13px;
}

.hero-note {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-top: 26px;
    color: var(--muted);
    font-size: 13px;
}

.hero-note strong {
    color: var(--dark);
}

.hero-image-wrap {
    position: relative;
}

.hero-image {
    display: block;
    width: 100%;
    height: 390px;
    object-fit: cover;
    border-radius: 28px;
    box-shadow: 0 24px 55px rgba(89, 48, 23, 0.17);
}

.image-badge {
    position: absolute;
    left: -18px;
    bottom: 22px;
    padding: 14px 18px;
    background: var(--white);
    border: 1px solid var(--border);
    border-radius: 13px;
    box-shadow: var(--shadow);
    font-size: 13px;
    font-weight: 700;
}

.image-badge span {
    display: block;
    color: var(--green);
    font-size: 12px;
    font-weight: 600;
}

/* BENEFITS */

.benefits {
    padding: 28px 0;
    background: var(--white);
    border-bottom: 1px solid var(--border);
}

.benefit-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 20px;
}

.benefit {
    display: flex;
    align-items: center;
    gap: 12px;
}

.benefit-icon {
    flex-shrink: 0;
    width: 46px;
    height: 46px;
    display: grid;
    place-items: center;
    border-radius: 13px;
    background: #fff0e5;
    font-size: 22px;
}

.benefit h3 {
    font-size: 14px;
    margin-bottom: 2px;
}

.benefit p {
    color: var(--muted);
    font-size: 12px;
}

/* SECTION */

.section {
    padding: 76px 0;
}

.section-heading {
    margin-bottom: 34px;
    text-align: center;
}

.section-label {
    display: block;
    margin-bottom: 10px;
    color: var(--primary);
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 1.8px;
    text-transform: uppercase;
}

.section-heading h2 {
    margin-bottom: 12px;
    font-size: clamp(28px, 4vw, 39px);
    line-height: 1.2;
    letter-spacing: -1px;
}

.section-heading p {
    max-width: 580px;
    margin: auto;
    color: var(--muted);
    font-size: 15px;
}

/* FOOD CARDS */

.food-grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 22px;
}

.food-card {
    overflow: hidden;
    background: var(--white);
    border: 1px solid var(--border);
    border-radius: 17px;
    box-shadow: 0 6px 24px rgba(40, 34, 31, 0.04);
    transition: transform 0.25s, box-shadow 0.25s;
}

.food-card:hover {
    transform: translateY(-5px);
    box-shadow: var(--shadow);
}

.food-image-wrap {
    position: relative;
    overflow: hidden;
    background: #f5eee8;
}

.food-card img {
    display: block;
    width: 100%;
    height: 210px;
    object-fit: cover;
    transition: transform 0.35s;
}

.food-card:hover img {
    transform: scale(1.04);
}

.food-type {
    position: absolute;
    top: 12px;
    left: 12px;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 9px;
    border: 1px solid #dcebdd;
    border-radius: 7px;
    background: rgba(255, 255, 255, 0.96);
    color: var(--green);
    font-size: 11px;
    font-weight: 800;
}

.food-type.non-veg {
    color: #c62828;
    border-color: #f2caca;
}

.food-dot {
    width: 8px;
    height: 8px;
    border: 1px solid currentColor;
    border-radius: 50%;
    background: currentColor;
}

.food-info {
    padding: 18px;
}

.food-info h3 {
    margin-bottom: 7px;
    font-size: 18px;
}

.food-info p {
    min-height: 43px;
    color: var(--muted);
    font-size: 13px;
    line-height: 1.65;
}

.food-bottom {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 8px;
    margin-top: 17px;
    padding-top: 14px;
    border-top: 1px solid #f3ece6;
}

.price {
    color: var(--primary-dark);
    font-size: 21px;
    font-weight: 800;
    white-space: nowrap;
}

.small-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 10px 12px;
    border-radius: 8px;
    background: var(--primary);
    color: var(--white);
    text-decoration: none;
    font-size: 12px;
    font-weight: 750;
    white-space: nowrap;
}

.small-btn:hover {
    background: var(--primary-dark);
}

/* FALLBACK IF PHOTO DOES NOT LOAD */

.food-image-wrap.food-fallback {
    min-height: 210px;
    display: grid;
    place-items: center;
    background: linear-gradient(135deg, #ffe2c2, #fff4e8);
}

.food-image-wrap.food-fallback::after {
    content: attr(data-food);
    padding: 25px 12px;
    color: #8d3518;
    font-size: 25px;
    font-weight: 800;
    text-align: center;
}

/* MENU ACTION */

.menu-action {
    margin-top: 35px;
    text-align: center;
}

.menu-note {
    margin-top: 12px;
    color: var(--muted);
    font-size: 12px;
}

/* HOW IT WORKS */

.how-section {
    background: #fff3e8;
}

.steps-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 24px;
}

.step-card {
    padding: 28px 24px;
    background: var(--white);
    border: 1px solid var(--border);
    border-radius: 16px;
}

.step-number {
    display: grid;
    place-items: center;
    width: 45px;
    height: 45px;
    margin-bottom: 18px;
    border-radius: 13px;
    background: #fff0e5;
    color: var(--primary-dark);
    font-size: 19px;
    font-weight: 800;
}

.step-card h3 {
    margin-bottom: 8px;
    font-size: 18px;
}

.step-card p {
    color: var(--muted);
    font-size: 14px;
    line-height: 1.8;
}

/* CALL TO ACTION */

.cta {
    padding: 0 0 76px;
}

.cta-panel {
    position: relative;
    overflow: hidden;
    padding: 48px 35px;
    border-radius: 23px;
    background:
        radial-gradient(circle at 95% 10%, #79462f 0, transparent 34%),
        #30231d;
    color: var(--white);
    text-align: center;
}

.cta-panel h2 {
    margin-bottom: 12px;
    font-size: clamp(27px, 4vw, 36px);
}

.cta-panel p {
    max-width: 570px;
    margin: 0 auto 24px;
    color: #e6d7ce;
    font-size: 14px;
    line-height: 1.8;
}

.cta-actions {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    gap: 12px;
}

.cta-panel .btn-outline {
    background: transparent;
    border-color: #877368;
    color: var(--white);
}

.cta-panel .btn-outline:hover {
    background: #49352a;
}

/* FOOTER */

footer {
    padding: 43px 0 20px;
    background: #211914;
    color: var(--white);
}

.footer-main {
    display: grid;
    grid-template-columns: 1.4fr 1fr 1fr;
    gap: 40px;
    padding-bottom: 32px;
}

.footer-brand p {
    max-width: 340px;
    margin-top: 15px;
    color: #cbbdb3;
    font-size: 13px;
    line-height: 1.9;
}

.footer-title {
    margin-bottom: 13px;
    font-size: 14px;
}

.footer-links {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    gap: 9px;
}

.footer-links a {
    color: #d5c7bd;
    font-size: 13px;
    text-decoration: none;
}

.footer-links a:hover {
    color: #ffb48e;
}

.footer-bottom {
    padding-top: 18px;
    border-top: 1px solid #493a31;
    color: #b9a99e;
    font-size: 12px;
    text-align: center;
}

/* RESPONSIVE */

@media (max-width: 1000px) {
    .hero-inner {
        gap: 35px;
    }

    .food-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .benefit-grid {
        grid-template-columns: repeat(2, 1fr);
    }

    .hero-image {
        height: 340px;
    }
}

@media (max-width: 720px) {
    .container {
        width: 90%;
    }

    .navbar {
        width: 92%;
        padding: 13px 0;
        flex-direction: column;
        gap: 13px;
    }

    nav {
        gap: 12px 17px;
    }

    nav a {
        font-size: 13px;
    }

    nav .nav-cta {
        padding: 9px 12px;
    }

    .hero {
        padding: 48px 0 55px;
    }

    .hero-inner {
        grid-template-columns: 1fr;
        gap: 30px;
    }

    .hero h1 {
        font-size: clamp(39px, 10vw, 54px);
        letter-spacing: -1.5px;
    }

    .hero-image {
        height: 280px;
    }

    .image-badge {
        left: 10px;
    }

    .section {
        padding: 56px 0;
    }

    .steps-grid {
        grid-template-columns: 1fr;
        gap: 15px;
    }

    .footer-main {
        grid-template-columns: 1fr 1fr;
        gap: 28px;
    }

    .footer-brand {
        grid-column: 1 / -1;
    }

    .cta {
        padding-bottom: 55px;
    }
}

@media (max-width: 430px) {
    .food-grid {
        grid-template-columns: 1fr;
    }

    .food-card img {
        height: 220px;
    }

    .benefit-grid {
        grid-template-columns: 1fr;
    }

    .hero-actions,
    .cta-actions {
        flex-direction: column;
    }

    .hero-actions .btn,
    .cta-actions .btn {
        width: 100%;
    }

    .footer-main {
        grid-template-columns: 1fr;
    }

    .footer-brand {
        grid-column: auto;
    }

    .cta-panel {
        padding: 36px 22px;
    }
}

@media (prefers-reduced-motion: reduce) {
    *,
    *::before,
    *::after {
        scroll-behavior: auto !important;
        transition: none !important;
    }
}
</style>
</head>

<body>

<header>
    <div class="navbar">
        <a class="logo" href="#home" aria-label="Swadisht Home">
            <span class="logo-icon">🍽️</span>
            <span>Swadisht<span style="color:#30231d">.</span></span>
        </a>

        <nav aria-label="Main navigation">
            <a href="#home">Home</a>
            <a href="#menu">Our Menu</a>
            <a href="#how-it-works">How It Works</a>
            <a href="order-tracking.jsp">Track Order</a>
            <a href="admin.jsp">Admin</a>
            <a class="nav-cta" href="place-order.jsp">Order Now →</a>
        </nav>
    </div>
</header>

<main>

<section class="hero" id="home">
    <div class="container hero-inner">
        <div class="hero-content">
            <div class="eyebrow">✦ GOOD FOOD, GOOD MOOD</div>

            <h1>
                Delicious food.<br>
                <span>Delivered with love.</span>
            </h1>

            <p class="hero-description">
                Discover your favourite flavours at Swadisht.
                Explore delicious meals, place your food order
                and follow your order status online.
            </p>

            <div class="hero-actions">
                <a class="btn" href="#menu">Explore Our Menu <span>→</span></a>
                <a class="btn btn-outline" href="order-tracking.jsp">Track My Order</a>
            </div>

            <div class="hero-note">
                <span aria-hidden="true">✓</span>
                <span><strong>Simple ordering</strong> · Convenient order management</span>
            </div>
        </div>

        <div class="hero-image-wrap">
            <img
                class="hero-image"
                src="https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&amp;fit=crop&amp;w=1000&amp;q=85"
                alt="A colourful plate of fresh food"
                fetchpriority="high"
                onerror="this.onerror=null;this.style.display='none';this.parentElement.classList.add('food-fallback');this.parentElement.setAttribute('data-food','🍽️ Delicious Food');">

            <div class="image-badge">
                🍴 Made for food lovers
                <span>Discover something delicious</span>
            </div>
        </div>
    </div>
</section>

<section class="benefits" aria-label="Our highlights">
    <div class="container benefit-grid">
        <div class="benefit">
            <div class="benefit-icon" aria-hidden="true">🥗</div>
            <div>
                <h3>Food Variety</h3>
                <p>Explore tasty favourites</p>
            </div>
        </div>

        <div class="benefit">
            <div class="benefit-icon" aria-hidden="true">🧾</div>
            <div>
                <h3>Easy Ordering</h3>
                <p>A convenient order flow</p>
            </div>
        </div>

        <div class="benefit">
            <div class="benefit-icon" aria-hidden="true">📦</div>
            <div>
                <h3>Order Tracking</h3>
                <p>Check your order status</p>
            </div>
        </div>

        <div class="benefit">
            <div class="benefit-icon" aria-hidden="true">💻</div>
            <div>
                <h3>Online Management</h3>
                <p>Organised order records</p>
            </div>
        </div>
    </div>
</section>

<section class="section" id="menu">
    <div class="container">
        <div class="section-heading">
            <span class="section-label">Our Selection</span>
            <h2>Popular on Our Menu</h2>
            <p>
                Explore a few favourites from our menu.
                Visit the ordering page to continue with your order.
            </p>
        </div>

        <div class="food-grid">

            <!-- VEG BIRYANI -->
            <article class="food-card">
                <div class="food-image-wrap">
                    <img
                        src="https://images.unsplash.com/photo-1630409346824-4f0e7b080087?auto=format&amp;fit=crop&amp;w=700&amp;q=80"
                        alt="Vegetable biryani"
                        loading="lazy"
                        onerror="this.onerror=null;this.style.display='none';this.parentElement.classList.add('food-fallback');this.parentElement.setAttribute('data-food','🥘 Veg Biryani');">

                    <span class="food-type"><span class="food-dot"></span> VEG</span>
                </div>

                <div class="food-info">
                    <h3>Veg Biryani</h3>
                    <p>Aromatic rice with vegetables and Indian spices.</p>

                    <div class="food-bottom">
                        <span class="price">₹120</span>
                        <a class="small-btn" href="place-order.jsp">Order Now</a>
                    </div>
                </div>
            </article>

            <!-- CHEESE PIZZA -->
            <article class="food-card">
                <div class="food-image-wrap">
                    <img
                        src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&amp;fit=crop&amp;w=700&amp;q=80"
                        alt="Cheese pizza"
                        loading="lazy"
                        onerror="this.onerror=null;this.style.display='none';this.parentElement.classList.add('food-fallback');this.parentElement.setAttribute('data-food','🍕 Cheese Pizza');">

                    <span class="food-type"><span class="food-dot"></span> VEG</span>
                </div>

                <div class="food-info">
                    <h3>Cheese Pizza</h3>
                    <p>Cheesy goodness with delicious toppings.</p>

                    <div class="food-bottom">
                        <span class="price">₹150</span>
                        <a class="small-btn" href="place-order.jsp">Order Now</a>
                    </div>
                </div>
            </article>

            <!-- SAMOSA -->
            <article class="food-card">
                <div class="food-image-wrap">
                    <img
                        src="https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&amp;fit=crop&amp;w=700&amp;q=80"
                        alt="Indian samosas"
                        loading="lazy"
                        onerror="this.onerror=null;this.style.display='none';this.parentElement.classList.add('food-fallback');this.parentElement.setAttribute('data-food','🥟 Samosa');">

                    <span class="food-type"><span class="food-dot"></span> VEG</span>
                </div>

                <div class="food-info">
                    <h3>Samosa</h3>
                    <p>Crispy pastry with a delicious savoury filling.</p>

                    <div class="food-bottom">
                        <span class="price">₹30</span>
                        <a class="small-btn" href="place-order.jsp">Order Now</a>
                    </div>
                </div>
            </article>

            <!-- PANEER CURRY -->
            <article class="food-card">
                <div class="food-image-wrap">
                    <img
                        src="https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&amp;fit=crop&amp;w=700&amp;q=80"
                        alt="Indian paneer curry"
                        loading="lazy"
                        onerror="this.onerror=null;this.style.display='none';this.parentElement.classList.add('food-fallback');this.parentElement.setAttribute('data-food','🍛 Paneer Curry');">

                    <span class="food-type"><span class="food-dot"></span> VEG</span>
                </div>

                <div class="food-info">
                    <h3>Paneer Curry</h3>
                    <p>Rich curry with paneer and Indian spices.</p>

                    <div class="food-bottom">
                        <span class="price">₹100</span>
                        <a class="small-btn" href="place-order.jsp">Order Now</a>
                    </div>
                </div>
            </article>

            <!-- CHICKEN CURRY -->
            <article class="food-card">
                <div class="food-image-wrap">
                    <img
                        src="https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?auto=format&amp;fit=crop&amp;w=700&amp;q=80"
                        alt="Chicken Curry"
                        loading="lazy"
                        onerror="this.onerror=null;this.style.display='none';this.parentElement.classList.add('food-fallback');this.parentElement.setAttribute('data-food','🍗 Chicken Curry');">

                    <span class="food-type non-veg"><span class="food-dot"></span> NON-VEG</span>
                </div>

                <div class="food-info">
                    <h3>Chicken Curry</h3>
                    <p>Tender chicken cooked in a rich Indian-spiced gravy.</p>

                    <div class="food-bottom">
                        <span class="price">₹180</span>
                        <a class="small-btn" href="place-order.jsp">Order Now</a>
                    </div>
                </div>
            </article>

            <!-- CHICKEN BIRYANI -->
            <article class="food-card">
                <div class="food-image-wrap">
                    <img
                        src="https://images.unsplash.com/photo-1633945274405-b6c8069047b0?auto=format&amp;fit=crop&amp;w=700&amp;q=80"
                        alt="Chicken Biryani"
                        loading="lazy"
                        onerror="this.onerror=null;this.style.display='none';this.parentElement.classList.add('food-fallback');this.parentElement.setAttribute('data-food','🍛 Chicken Biryani');">

                    <span class="food-type non-veg"><span class="food-dot"></span> NON-VEG</span>
                </div>

                <div class="food-info">
                    <h3>Chicken Biryani</h3>
                    <p>Fragrant basmati rice with chicken and aromatic spices.</p>

                    <div class="food-bottom">
                        <span class="price">₹200</span>
                        <a class="small-btn" href="place-order.jsp">Order Now</a>
                    </div>
                </div>
            </article>

        </div> <!-- End food-grid -->

        <div class="menu-action">
            <a class="btn" href="place-order.jsp">Continue to Ordering Page →</a>
            <p class="menu-note">
                Prices shown are sample display prices. Confirm the final price on the ordering page.
            </p>
        </div>
    </div>
</section>

<section class="section how-section" id="how-it-works">
    <div class="container">
        <div class="section-heading">
            <span class="section-label">A Simple Process</span>
            <h2>How It Works</h2>
            <p>Follow these steps to use the Swadisht ordering system.</p>
        </div>

        <div class="steps-grid">
            <article class="step-card">
                <div class="step-number">01</div>
                <h3>Explore the Menu</h3>
                <p>Browse the available food items and choose what you would like to order.</p>
            </article>

            <article class="step-card">
                <div class="step-number">02</div>
                <h3>Place Your Order</h3>
                <p>Continue to the ordering page and follow the available order instructions.</p>
            </article>

            <article class="step-card">
                <div class="step-number">03</div>
                <h3>Track Your Order</h3>
                <p>Open the order tracking page to check the status using the available tracking process.</p>
            </article>
        </div>
    </div>
</section>

<section class="cta">
    <div class="container">
        <div class="cta-panel">
            <h2>Ready for Something Delicious?</h2>
            <p>
                Explore the ordering page to get started.
                If you have already placed an order, use the tracking page to check its status.
            </p>

            <div class="cta-actions">
                <a class="btn" href="place-order.jsp">Place an Order →</a>
                <a class="btn btn-outline" href="order-tracking.jsp">Track an Order</a>
            </div>
        </div>
    </div>
</section>

</main>
<h1 style="background:yellow;padding:20px;">TEST 123</h1>
<footer id="contact">
    <div class="container">
        <div class="footer-main">
            <div class="footer-brand">
                <a class="logo" href="#home">
                    <span class="logo-icon">🍽️</span>
                    <span>Swadisht<span style="color:#ffffff">.</span></span>
                </a>

                <p>
                    Swadisht Food Ordering System is a web application
                    project designed to make food ordering and order
                    management more convenient.
                </p>
            </div>

            <div>
                <h3 class="footer-title">Quick Links</h3>
                <div class="footer-links">
                    <a href="#home">Home</a>
                    <a href="#menu">Our Menu</a>
                    <a href="#how-it-works">How It Works</a>
                    <a href="place-order.jsp">Place an Order</a>
                </div>
            </div>

            <div>
                <h3 class="footer-title">Order &amp; Support</h3>
                <div class="footer-links">
                    <a href="order-tracking.jsp">Track Order</a>
                    <a href="admin.jsp">Admin Panel</a>
                </div>
            </div>
        </div>

        <div class="footer-bottom">
            &copy; 2026 Swadisht Food Ordering System. All rights reserved.
        </div>
    </div>
</footer>

</body>
</html>