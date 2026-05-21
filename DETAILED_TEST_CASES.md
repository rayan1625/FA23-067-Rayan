# TechZone E-Commerce Test Cases

**Project:** TechZone - Full Stack E-commerce Website (Laravel 12)  
**Date Created:** April 30, 2026  
**Total Test Cases:** 28  
**Modules:** Product Catalog (14 cases) + Home Page (10 cases) + Edge Cases (4 cases)

---

## MODULE 1: PRODUCT CATALOG (PC-01 to PC-14)

| Scenario TID | Scenario Description | Test Case ID | Pre Condition | Steps to Execute | Expected Result | Actual Result | Status | Executed QA Name | Misc (Comments) | Pri |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Load products page successfully | PC-01 | User navigates to /products page | 1. Open browser 2. Navigate to TechZone /products page 3. Wait for page to fully load | Products page loads within 2 seconds; grid displays all products with images, names, prices, and brands; no 404 errors or blank areas; pagination visible | | | | Page should load via Vite asset compilation | High |
| 2 | Display product cards with complete information | PC-02 | Products exist in database; at least 5 products available | 1. Navigate to /products 2. Observe first 5 product cards 3. Verify all product details display | Each product card shows: product image, product name, brand (e.g., "Dell", "Sony"), price (₹ formatted), rating (star), "Add to Cart" button; no truncated text; images load without broken links | | | | Verify images from /public/images load correctly | High |
| 3 | Real-time search filters products as user types | PC-03 | User is on /products page; at least 10 products exist (e.g., "Dell Laptop", "Sony Headphones", "Samsung Galaxy", "Apple iPhone") | 1. Locate search input field 2. Type "Dell" character by character 3. Observe results update in real-time (each keystroke) 4. Wait 500ms between keystrokes | Products containing "Dell" appear instantly without page reload; AJAX request fires as each character typed; results filter in real-time; other products fade/hide; product count updates dynamically (e.g., "Showing 2 of 15 products") | | | | Real-time search must use AJAX without page reload; no loading delay > 300ms | High |
| 4 | Search returns no results for non-matching keyword | PC-04 | Products page loaded; products exist | 1. Type non-existent keyword (e.g., "xyz999zzz") in search field 2. Wait for AJAX update 3. Observe empty results | "No products found" message displays; product grid becomes empty; search term remains in input field; user can clear and search again; no errors in console | | | | Verify graceful handling of empty results | Medium |
| 5 | Search is case-insensitive and handles special characters | PC-05 | Products page loaded | 1. Search "SAMSUNG" (uppercase) 2. Wait for results 3. Clear and search "samsung" (lowercase) 4. Compare result counts | Both searches return identical results (e.g., "Samsung Galaxy" products); case does not affect filtering; partial matches work ("Sam" returns "Samsung..."); special characters handled correctly | | | | Test: SAMSUNG = samsung = SaMsUng | Medium |
| 6 | Clear search and restore full product list | PC-06 | A search has been performed and results filtered | 1. Perform search (e.g., "Dell") 2. Clear search input field (click X or backspace all) 3. Wait for AJAX update | All products reappear instantly; product count returns to total (e.g., "Showing 15 of 15 products"); search field empty; AJAX refresh occurs without page reload | | | | Clear functionality must be instant | High |
| 7 | Filter by single category | PC-07 | Products page loaded; products in multiple categories exist (Smartphones, Laptops, Headphones) | 1. Navigate to /products 2. Click category filter (e.g., "Laptops") 3. Wait for AJAX update | Only "Laptop" products display (e.g., "Dell Laptop", "HP Laptop"); product count updates (e.g., "Showing 3 of 15"); category checkbox marked as selected; no page reload; results update instantly | | | | Filters should use AJAX for instant updates | High |
| 8 | Filter by multiple categories using AND logic | PC-08 | Products in multiple categories exist | 1. Click first category checkbox (e.g., "Smartphones") 2. Click second category checkbox (e.g., "Accessories") 3. Wait for AJAX update 4. Observe filtered results | Products displayed must belong to BOTH selected categories (AND logic applied); OR logic NOT used; product count reflects intersection; both category checkboxes marked as selected; results update instantly | | | | CRITICAL: AND logic required (not OR). Results should show only products matching ALL filters simultaneously | High |
| 9 | Filter by single brand | PC-09 | Products page loaded; products with multiple brands exist (Apple, Samsung, Dell, Sony) | 1. Navigate to /products 2. Click brand filter (e.g., "Apple") 3. Wait for AJAX update | Only Apple products display (e.g., "Apple iPhone", "Apple Watch"); brand checkbox marked as selected; product count updates; AJAX fires, no page reload; other brands remain visible in filter list | | | | Multiple brand selection should work with AND logic | High |
| 10 | Filter by price range slider | PC-10 | Products with varying prices exist (₹5,000 to ₹2,00,000) | 1. Navigate to /products 2. Adjust minimum price slider to ₹10,000 3. Adjust maximum price slider to ₹1,00,000 4. Trigger filter (or AJAX auto-fires) | Only products between ₹10,000-₹1,00,000 display; products outside range disappear; price filter input/slider shows selected range; product count updates; AJAX response fast (< 500ms); no page reload | | | | Ensure slider is smooth and responsive; AJAX should fire on slider release or input change | High |
| 11 | Combine all filters: Category + Brand + Price (AND logic) | PC-11 | Multiple products across categories, brands, prices exist | 1. Filter by Category: "Smartphones" 2. Filter by Brand: "Samsung" 3. Filter by Price: ₹20,000-₹80,000 4. Wait for AJAX | Products shown must match ALL three filters (AND logic): Category=Smartphones AND Brand=Samsung AND Price between ₹20,000-₹80,000; product count minimal but accurate; all three filters marked as active; no page reload | | | | CRITICAL: AND logic must apply across all filter types. Only show products matching ALL selected criteria | High |
| 12 | Product details page loads with complete information | PC-12 | User on /products page; click any product (e.g., "Dell Laptop") | 1. Navigate to /products 2. Click on a product card/image 3. Wait for page to load | Product details page loads (/product/{id}); displays: product name, large image, price, brand, rating (stars), description, specifications; "Add to Cart" button visible; back button/link returns to products page; URL changes to /product/{id} | | | | Verify all product details render correctly; no broken links | High |
| 13 | Related products display on product details page | PC-13 | Product details page loaded (e.g., "Samsung Galaxy A15") | 1. Navigate to product details page 2. Scroll down to "Related Products" section 3. Observe related products list | Related products section displays (if implemented); shows 3-5 products from same category or brand; each product card clickable; clicking related product loads its details page; no broken images | | | | Related products should be from same category/brand; verify they load dynamically | Medium |
| 14 | Responsive design: Products page on mobile (375px width) | PC-14 | Chrome DevTools available; products page open | 1. Open Chrome DevTools (F12) 2. Toggle device toolbar (Ctrl+Shift+M) 3. Select iPhone SE (375x667) 4. Reload page 5. Verify layout | Products display in 1 column on mobile (not 2-3); search input and filters stack vertically; hamburger menu for filters appears (or sidebar collapses); text readable; no horizontal scroll; images scale properly; pagination works | | | | Test on actual mobile devices if possible (iPhone SE, Samsung S20). Verify touch-friendly tap targets | High |

---

## MODULE 2: HOME PAGE (HP-01 to HP-10)

| Scenario TID | Scenario Description | Test Case ID | Pre Condition | Steps to Execute | Expected Result | Actual Result | Status | Executed QA Name | Misc (Comments) | Pri |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Home page loads successfully | HP-01 | User navigates to TechZone home page (/) | 1. Open browser 2. Navigate to http://techzone.local or TechZone home URL 3. Wait for page to fully load | Home page loads within 2 seconds; hero section displays "Big Gadget Sale" heading; featured products section visible; navigation menu intact; no 404 errors; all CSS/JS loaded | | | | Home page should load quickly (< 2sec); verify Vite asset bundling works | High |
| 2 | Hero section displays with proper styling | HP-02 | User is on home page | 1. Observe hero section at top of page 2. Check heading, subtext, and CTA button | Hero section displays full-width with background image/color; "Big Gadget Sale" heading prominent; subtitle text visible; CTA button (e.g., "Shop Now") styled and clickable; no broken images | | | | Hero should have good visual contrast; text readable over background | Medium |
| 3 | Featured/top-rated products section displays | HP-03 | At least 3-4 featured products exist in database (marked as featured=true or similar) | 1. Navigate to home page 2. Scroll to featured products section 3. Count visible products 4. Verify product cards display | Featured products section displays with heading (e.g., "Featured Products" or "Top Rated"); products shown in grid (2-4 columns depending on screen size); each product card shows: image, name, brand, price, rating (stars); "View Details" or "Add to Cart" buttons visible | | | | Featured products should load dynamically from database (query with featured flag) | High |
| 4 | Featured product cards are interactive and clickable | HP-04 | Featured products section visible on home page | 1. Click on a featured product card (name or image) 2. Wait for navigation 3. Observe product details page | Clicking product navigates to /product/{id} page; correct product details load; all information matches the featured product clicked; back button returns to home page; no 404 errors | | | | Verify product IDs are correctly passed in URLs; test clicking on different products | High |
| 5 | Featured products show accurate ratings | HP-05 | Featured products displayed | 1. View featured products section 2. Check star ratings on each product 3. Click one product to verify rating in details page | Each featured product displays rating (e.g., 4.5 stars, 4 out of 5); rating matches database value; star display consistent (filled stars for rating value); clicking product confirms same rating on details page | | | | Ratings should come from database Product.rating column; verify calculation if average rating used | Medium |
| 6 | Category navigation section functions correctly | HP-06 | Home page loaded; multiple product categories exist (Smartphones, Laptops, Headphones, Accessories) | 1. Locate category browse section (if implemented) 2. Click on a category (e.g., "Smartphones") 3. Wait for navigation | Clicking category navigates to /products page with category pre-filtered (e.g., /products?category=smartphones); only products in that category display; category filter automatically applied; product count reflects filtered results | | | | Category navigation should apply filters automatically via URL parameters | Medium |
| 7 | "View All Products" or "Shop Now" CTA button works | HP-07 | Home page loaded | 1. Locate main CTA button (e.g., "Shop Now" in hero or "View All Products" button) 2. Click button 3. Wait for page load | Clicking CTA navigates to /products page; full product catalog displays; no filters pre-applied (shows all products); pagination available if needed; URL changes to /products | | | | Button should be clearly visible and styled; verify click targets are at least 44px x 44px for mobile | High |
| 8 | Responsive design: Home page on mobile (375px width) | HP-08 | Chrome DevTools available; home page open | 1. Open DevTools (F12) 2. Toggle device toolbar (Ctrl+Shift+M) 3. Select iPhone SE (375x667) 4. Reload page | Hero section stacks properly; featured products display in 1 column on mobile; text readable without zooming; no horizontal scroll; nav menu collapses to hamburger; images scale responsively; buttons touch-friendly (44px minimum) | | | | Test on actual mobile: iPhone SE, Samsung S20. Verify landscape orientation works too | High |
| 9 | Responsive design: Home page on tablet (768px width) | HP-09 | Chrome DevTools available | 1. Toggle device toolbar 2. Select iPad (768x1024) 3. Reload page 4. Verify layout | Featured products display in 2 columns on tablet; hero section optimized for 768px width; navigation readable; spacing appropriate; images load correctly; no overflow or crammed content; pagination visible | | | | Tablet breakpoint should be around 768px; verify CSS media queries working | Medium |
| 10 | Performance: Home page loads and renders under 3 seconds | HP-10 | Chrome DevTools Network tab available | 1. Open Chrome DevTools 2. Go to Network tab 3. Reload home page 4. Check load time (DOMContentLoaded + Load events) 5. Check Lighthouse performance score | Page DOMContentLoaded time: < 1.5 seconds; Full page Load: < 3 seconds; First Contentful Paint (FCP): < 1.2 seconds; Lighthouse Performance score: > 80; all images lazy-loaded where applicable; no render-blocking CSS/JS | | | | Use Chrome Lighthouse for performance audit; check for unused CSS/JS; optimize image sizes | High |

---

## ADDITIONAL EDGE CASES (EC-01 to EC-04)

| Scenario TID | Scenario Description | Test Case ID | Pre Condition | Steps to Execute | Expected Result | Actual Result | Status | Executed QA Name | Misc (Comments) | Pri |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Search with special characters and SQL injection attempt | EC-01 | Products page loaded | 1. Type search: "'; DROP TABLE--" or "@#$%^&*()" in search field 2. Wait for AJAX results | Search is sanitized; no error or page crash; results show "No products found" or safely handle special characters as literal string; database integrity unaffected; no SQL injection vulnerability | | | | Security test: verify input sanitization; use prepared statements in queries | Medium |
| 2 | Filter with empty product database | EC-02 | Admin deletes all products from database | 1. Navigate to /products 2. Attempt search or apply any filter 3. Observe page behavior | "No products found" message displays; page does not crash; filters still visible (user can clear them); home page still loads properly; no broken references | | | | Edge case: graceful handling of empty inventory | Low |
| 3 | Combine 10+ filters simultaneously (stress test) | EC-03 | Multiple filter options available (10+ categories, 10+ brands) | 1. Select 5 categories checkboxes 2. Select 5 brands checkboxes 3. Set price range 4. Enter search term 5. Wait for results | All filters applied with AND logic (must match ALL); AJAX response time < 1000ms even with many filters; product count accurate; no performance degradation; page remains responsive | | | | Test AJAX performance with complex queries; verify database query optimization | Medium |
| 4 | Mobile: Rapidly toggle filters on/off | EC-04 | Mobile view (375px); filters visible | 1. Open on iPhone SE 2. Toggle category filter on 3. Immediately toggle off 4. Toggle brand filter on 5. Rapidly toggle multiple filters 6. Observe AJAX requests | AJAX requests handled correctly; no duplicate requests; results update accurately despite rapid clicking; no race conditions; UI responsive; no frozen/stuck states | | | | Test on actual mobile to verify touch responsiveness; check Network tab for AJAX request queuing | Medium |

---

## TEST EXECUTION CHECKLIST

### Pre-Test Setup
- [ ] Test database contains minimum 15-20 products
- [ ] Products distributed across 3-4 categories (Smartphones, Laptops, Headphones, Accessories)
- [ ] Products from 4-5 brands (Apple, Samsung, Dell, Sony, HP)
- [ ] Price range: ₹5,000 to ₹2,00,000
- [ ] At least 3-4 products marked as featured
- [ ] Product images exist in /public/images directory
- [ ] Laravel app running on http://localhost:8000 or equivalent
- [ ] Vite dev server running for asset compilation

### Browser Testing
- [ ] Google Chrome (latest version)
- [ ] Mozilla Firefox (latest version)
- [ ] Safari (on macOS)
- [ ] Edge (on Windows)
- [ ] Mobile browsers: Safari (iOS), Chrome (Android)

### Device Testing
- [ ] Desktop (1920x1080)
- [ ] Tablet (iPad 768x1024)
- [ ] Mobile (iPhone SE 375x667)
- [ ] Mobile Landscape (667x375)

### Performance Metrics to Record
- Page Load Time (DOMContentLoaded)
- Full Load Time
- AJAX Response Time for searches/filters
- First Contentful Paint (FCP)
- Largest Contentful Paint (LCP)
- Cumulative Layout Shift (CLS)

---

## DEFECT REPORTING TEMPLATE

When a test case fails, log a defect with:
- **Defect ID**: PC-BUG-01, HP-BUG-01, etc.
- **Test Case ID**: Reference failing test (e.g., PC-03)
- **Severity**: Critical, High, Medium, Low
- **Steps to Reproduce**: Exact steps from test case
- **Expected vs Actual**: What should happen vs what happens
- **Environment**: Browser, OS, device, screen size
- **Screenshots/Video**: Attach evidence
- **Console Errors**: Check DevTools Console tab

---

## NOTES FOR QA TEAM

1. **AJAX Testing**: 
   - Use Chrome DevTools Network tab to verify AJAX requests fire
   - Ensure responses come from API endpoints (e.g., /api/products)
   - Verify no full page reloads occur during search/filter operations
   - Check response time in Network tab (target: < 500ms)

2. **Real-Time Search Performance**:
   - Use throttling/debouncing to avoid excessive AJAX requests
   - Test with slow network (Chrome DevTools: Slow 3G) to ensure UX doesn't break
   - Verify search results update as user types (not after blur/submit)

3. **Filter AND Logic**:
   - If user selects Category="Smartphones" AND Brand="Samsung", only show Samsung smartphones
   - NOT Samsung products from all categories (that would be OR logic)
   - Verify with product count: narrower results with more filters applied

4. **Responsive Design Testing**:
   - Use Chrome DevTools device emulation for quick tests
   - Test on actual devices for authentic touch/performance experience
   - Verify touch targets are at least 44x44 pixels (mobile accessibility)
   - Check landscape and portrait orientations

5. **Database Seeding**:
   - Run `php artisan db:seed` to populate test data
   - Use ProductSeeder to create 15+ products with varied categories/brands/prices
   - Mark at least 3 products as featured

6. **API Testing**:
   - Products listing: GET /api/products
   - Filtered products: GET /api/products?category=smartphones&brand=samsung&min_price=10000&max_price=100000
   - Verify JSON responses are properly formatted
   - Check for pagination (if implemented)

---

## TEST CASE SUMMARY

| Module | PC | HP | EC | Total |
|---|---|---|---|---|
| **Count** | 14 | 10 | 4 | 28 |
| **High Priority** | 10 | 6 | 0 | 16 |
| **Medium Priority** | 3 | 3 | 2 | 8 |
| **Low Priority** | 1 | 1 | 2 | 4 |
| **Positive Cases** | 8 | 8 | 0 | 16 |
| **Negative Cases** | 3 | 1 | 2 | 6 |
| **Edge Cases** | 3 | 1 | 4 | 8 |

---

**Document Version:** 2.0  
**Last Updated:** April 30, 2026  
**Prepared By:** QA Team  
**Total Estimated Time:** 40-50 hours for complete test execution
