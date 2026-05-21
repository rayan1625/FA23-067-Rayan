<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Contact – TechZone</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="{{ asset('css/style.css') }}" />
</head>
<body data-page="contact">
    <header class="tz-header">
        <div class="container nav">
            <a class="logo" href="{{ route('home') }}">TechZone</a>
            <nav class="menu" id="navMenu">
                <a href="{{ route('home') }}">Home</a>
                <a href="{{ route('products') }}">Products</a>
                @auth
                    <a href="{{ route('cart') }}">Cart <span class="cart-badge" id="cartCount">0</span></a>
                @endauth
                <a href="{{ route('about') }}">About</a>
                <a href="{{ route('contact') }}" class="active">Contact</a>
                @auth
                    @if(auth()->user()->isAdmin())
                        <a href="{{ route('admin') }}">Admin</a>
                    @endif
                    <form method="POST" action="{{ route('logout') }}" style="display: inline;">
                        @csrf
                        <button type="submit" style="background: none; border: none; color: inherit; cursor: pointer; padding: 10px 12px; border-radius: 12px; font-size: inherit; font-family: inherit;">Logout ({{ auth()->user()->name }})</button>
                    </form>
                @else
                    <a href="{{ route('login') }}">Login</a>
                    <a href="{{ route('register') }}">Register</a>
                @endauth
            </nav>
            <button class="hamburger" id="hamburger" aria-label="Toggle Menu">
                <span></span><span></span><span></span>
            </button>
        </div>
    </header>

    <main class="container">
        <h1 class="page-title">Contact Us</h1>
        <p style="color:#64748b;margin-top:-6px">We usually respond within 24 hours. For urgent queries, call or WhatsApp us.</p>
        <div class="contact-grid">
        <form id="contactForm" class="contact-form contact-card">
            <div class="form-field">
                <label for="name">Name</label>
                <input type="text" id="name" required />
            </div>
            <div class="form-field">
                <label for="email">Email</label>
                <input type="email" id="email" required />
            </div>
            <div class="form-field">
                <label for="subject">Subject</label>
                <input type="text" id="subject" placeholder="Order inquiry, product question, etc." required />
            </div>
            <div class="form-field">
                <label for="topic">Topic</label>
                <select id="topic" required>
                    <option value="">Select a topic</option>
                    <option>Order / Delivery</option>
                    <option>Returns / Refunds</option>
                    <option>Product Information</option>
                    <option>Partnership</option>
                    <option>Other</option>
                </select>
            </div>
            <div class="form-field">
                <label for="message">Message</label>
                <textarea id="message" rows="5" required></textarea>
            </div>
            <label style="display:flex;gap:8px;align-items:flex-start;color:#64748b">
                <input type="checkbox" id="consent" required style="margin-top:3px">
                I agree to be contacted regarding my inquiry and accept the privacy policy.
            </label>
            <div class="contact-actions">
                <button class="btn btn-primary" type="submit" id="sendBtn">Send Message</button>
                <a class="btn btn-ghost" href="mailto:support@techzone.store">Email Support</a>
            </div>
        </form>
        <div class="contact-info">
            <div class="info-card"><h4>Address</h4><p>TechZone HQ, Karachi, Pakistan</p></div>
            <div class="info-card"><h4>Business Hours</h4><p>Mon–Sat: 10:00 – 19:00 PKT<br>Sun: Closed</p></div>
            <div class="info-card"><h4>Phone / WhatsApp</h4><p><a href="tel:+923000000000">+92 300 0000000</a> · <a href="#">Chat on WhatsApp</a></p></div>
            <div class="map-embed">
                <iframe title="Map" src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3621.797387235091!2d67.0305!3d24.8022!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zMjTCsDQ4JzA4LjAiTiA2N8KwMDEnNDkuOCJF!5e0!3m2!1sen!2s!4v1700000000000" width="100%" height="260" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
            </div>
            <div id="toast" class="toast" role="status" aria-live="polite" aria-atomic="true" hidden>Message sent. Our team will reply shortly.</div>
        </div>
        </div>
    </main>

    <footer class="tz-footer">
        <div class="container footer-grid">
            <div>
                <h3>TechZone</h3>
                <p>We'd love to hear from you.</p>
            </div>
        </div>
    </footer>

    <script src="{{ asset('js/script.js') }}"></script>
    <script>
        const form = document.getElementById('contactForm');
        const toast = document.getElementById('toast');
        const sendBtn = document.getElementById('sendBtn');
        form.addEventListener('submit', function(e){
            e.preventDefault();
            sendBtn.disabled = true;
            sendBtn.textContent = 'Sending...';
            setTimeout(()=>{
                this.reset();
                sendBtn.disabled = false;
                sendBtn.textContent = 'Send Message';
                toast.hidden = false;
                toast.classList.add('show');
                setTimeout(()=>{ toast.classList.remove('show'); toast.hidden = true; }, 2500);
            }, 800);
        });
    </script>
</body>
</html>


