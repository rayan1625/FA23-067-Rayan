# TechZone E-Commerce - Authentication & Admin Dashboard Test Cases

**Project:** TechZone - Full Stack E-commerce Website (Laravel 12)  
**Date Created:** April 30, 2026  
**Modules Tested:** User Authentication, Admin Dashboard  
**Total Test Cases:** 32  

---

## MODULE 1: USER AUTHENTICATION (AUTH-01 to AUTH-16)

### 1. User Registration - Positive Scenarios

| Scenario TID | Scenario Description | Test Case ID | Pre Condition | Steps to Execute | Expected Result | Actual Result | Status | Executed QA Name | Misc (Comments) | Pri |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Register with valid credentials | AUTH-01 | User is on /register page; database is empty or no duplicate email exists | 1. Navigate to /register 2. Enter Name: "John Doe" 3. Enter Email: "john@example.com" 4. Enter Password: "SecurePass123" 5. Confirm Password: "SecurePass123" 6. Click Register button | Registration successful; redirect to /login page; success message "Registration successful! Please login." displayed; user created in database with role='user' | | | | | High |
| 2 | Register with minimum required fields | AUTH-02 | User is on /register page | 1. Enter Name: "Jane" 2. Enter Email: "jane@test.com" 3. Enter Password: "Pass@1234" 4. Confirm Password: "Pass@1234" 5. Submit form | User registered successfully; redirect to login; all required fields accepted; form validation passes | | | | | High |
| 3 | Password confirmation matches correctly | AUTH-03 | User is on /register page | 1. Enter Name: "Test User" 2. Enter Email: "test@example.com" 3. Enter Password: "Match123Pass" 4. Enter Confirm Password: "Match123Pass" (identical) 5. Click Register | Registration completes; user created; no validation errors; confirmation passed | | | | | High |

---

### 2. User Registration - Negative Scenarios & Validation

| Scenario TID | Scenario Description | Test Case ID | Pre Condition | Steps to Execute | Expected Result | Actual Result | Status | Executed QA Name | Misc (Comments) | Pri |
|---|---|---|---|---|---|---|---|---|---|---|
| 4 | Register with missing name field | AUTH-04 | User is on /register page | 1. Leave Name field empty 2. Enter Email: "test@example.com" 3. Enter Password: "SecurePass123" 4. Confirm: "SecurePass123" 5. Click Register | Validation error displayed: "Name is required" or similar; form not submitted; user not created in database | | | | | High |
| 5 | Register with invalid email format | AUTH-05 | User is on /register page | 1. Enter Name: "John Doe" 2. Enter Email: "invalidemail" (no @ symbol) 3. Enter Password: "SecurePass123" 4. Confirm: "SecurePass123" 5. Submit | Validation error: "Email must be a valid email address"; form rejected; user not created | | | | | High |
| 6 | Register with duplicate email address | AUTH-06 | User "test@example.com" already exists in database | 1. Navigate to /register 2. Enter Name: "Another User" 3. Enter Email: "test@example.com" (existing email) 4. Enter Password: "SecurePass123" 5. Confirm: "SecurePass123" 6. Click Register | Validation error: "Email has already been taken" or "Email already exists"; form rejected; only one user with this email in database | | | | | High |
| 7 | Register with password less than 8 characters | AUTH-07 | User is on /register page | 1. Enter Name: "John Doe" 2. Enter Email: "john7@example.com" 3. Enter Password: "Short12" (7 characters) 4. Confirm: "Short12" 5. Submit | Validation error: "Password must be at least 8 characters" or similar; registration fails; user not created | | | | | High |
| 8 | Register with mismatched password confirmation | AUTH-08 | User is on /register page | 1. Enter Name: "Jane Doe" 2. Enter Email: "jane7@example.com" 3. Enter Password: "SecurePass123" 4. Confirm Password: "SecurePass124" (different) 5. Click Register | Validation error: "Password confirmation does not match" or similar; registration fails; no user created | | | | | High |
| 9 | Register with name exceeding 255 characters | AUTH-09 | User is on /register page | 1. Enter Name: (string of 256+ characters) 2. Enter Email: "testlong@example.com" 3. Enter Password: "SecurePass123" 4. Confirm: "SecurePass123" 5. Submit | Validation error: "Name may not be greater than 255 characters"; form rejected; user not created | | | | | Medium |
| 10 | Register with empty form (all fields blank) | AUTH-10 | User is on /register page | 1. Do not fill any form fields 2. Click Register button directly | Multiple validation errors appear; "Name is required", "Email is required", "Password is required"; form rejected | | | | | Medium |

---

### 3. User Login - Positive Scenarios

| Scenario TID | Scenario Description | Test Case ID | Pre Condition | Steps to Execute | Expected Result | Actual Result | Status | Executed QA Name | Misc (Comments) | Pri |
|---|---|---|---|---|---|---|---|---|---|---|
| 11 | Login with valid credentials (regular user) | AUTH-11 | User "user@example.com" (role='user') exists in database | 1. Navigate to /login 2. Enter Email: "user@example.com" 3. Enter Password: "SecurePass123" 4. Leave "Remember Me" unchecked 5. Click Login | Login successful; redirect to /home page; welcome message "Welcome back, [Name]!" displayed; session created; user authenticated | | | | | High |
| 12 | Login with valid admin credentials | AUTH-12 | User "admin@example.com" (role='admin') exists in database | 1. Navigate to /login 2. Enter Email: "admin@example.com" 3. Enter Password: "AdminPass123" 4. Click Login | Login successful; redirect to /home page; session created; admin can access /admin dashboard; session contains admin role | | | | | High |
| 13 | Login with Remember Me checked | AUTH-13 | User "user@example.com" exists in database | 1. Navigate to /login 2. Enter Email: "user@example.com" 3. Enter Password: "SecurePass123" 4. Check "Remember Me" checkbox 5. Click Login | Login successful; redirect to /home; remember_token generated in database; cookie created for future sessions; user auto-logged in on browser restart | | | | | High |

---

### 4. User Login - Negative Scenarios

| Scenario TID | Scenario Description | Test Case ID | Pre Condition | Steps to Execute | Expected Result | Actual Result | Status | Executed QA Name | Misc (Comments) | Pri |
|---|---|---|---|---|---|---|---|---|---|---|
| 14 | Login with non-existent email address | AUTH-14 | User "nonexistent@example.com" does NOT exist in database | 1. Navigate to /login 2. Enter Email: "nonexistent@example.com" 3. Enter Password: "AnyPassword123" 4. Click Login | Login fails; error message: "The provided credentials do not match our records." displayed; user not authenticated; session not created | | | | | High |
| 15 | Login with correct email but wrong password | AUTH-15 | User "user@example.com" exists with password "CorrectPass123" | 1. Navigate to /login 2. Enter Email: "user@example.com" 3. Enter Password: "WrongPassword456" 4. Click Login | Login fails; error message: "The provided credentials do not match our records."; authentication fails; user not logged in | | | | | High |
| 16 | Login without entering email field | AUTH-16 | User is on /login page | 1. Leave Email field empty 2. Enter Password: "SomePassword123" 3. Click Login | Validation error: "Email is required"; login not attempted; form stays on /login | | | | | Medium |

---

### 5. User Logout & Session Security

| Scenario TID | Scenario Description | Test Case ID | Pre Condition | Steps to Execute | Expected Result | Actual Result | Status | Executed QA Name | Misc (Comments) | Pri |
|---|---|---|---|---|---|---|---|---|---|---|
| 17 | Logout successfully clears session | AUTH-17 | User is logged in and on /home page | 1. Click Logout button 2. Observe redirect 3. Try accessing /cart (protected route) | Logout successful; redirect to /home; success message "You have been logged out."; session invalidated; trying to access /cart redirects to /login; cookies cleared | | | | | High |
| 18 | Session regeneration on login | AUTH-18 | User logs in to account | 1. Capture session ID before login 2. Login successfully 3. Capture new session ID after login | Old session ID is invalidated; new session ID generated; session_id() changes after successful login; security token regenerated | | | | | Medium |

---

### 6. Role-Based Access Control (RBAC)

| Scenario TID | Scenario Description | Test Case ID | Pre Condition | Steps to Execute | Expected Result | Actual Result | Status | Executed QA Name | Misc (Comments) | Pri |
|---|---|---|---|---|---|---|---|---|---|---|
| 19 | Regular user blocked from accessing /admin page | AUTH-19 | User with role='user' is logged in | 1. Login as regular user (user@example.com) 2. Try accessing /admin page (direct URL) | Access denied; HTTP 403 Forbidden error displayed; message "Unauthorized access. Admin privileges required."; redirect to home or error page | | | | | High |
| 20 | Admin user can access /admin page | AUTH-20 | User with role='admin' exists and is logged in | 1. Login as admin (admin@example.com) 2. Navigate to /admin page | Admin dashboard loads successfully; product list displayed; CRUD buttons visible (Add, Edit, Delete); no 403 error | | | | | High |
| 21 | Unauthenticated user cannot access /cart | AUTH-21 | User is NOT logged in | 1. Navigate directly to /cart without logging in 2. Observe behavior | Redirect to /login page; message "Please login to continue" (if implemented); unauthenticated users cannot see protected pages | | | | | High |
| 22 | Guest middleware prevents logged-in user from accessing /login | AUTH-22 | User is already logged in | 1. Login successfully 2. Try accessing /login page (direct URL) | Redirect to /home or intended page; logged-in user cannot re-access login page; guest middleware enforces this | | | | | Medium |

---

## MODULE 2: ADMIN DASHBOARD - PRODUCT CRUD (ADMIN-01 to ADMIN-16)

### 1. Add Product - Positive Scenarios

| Scenario TID | Scenario Description | Test Case ID | Pre Condition | Steps to Execute | Expected Result | Actual Result | Status | Executed QA Name | Misc (Comments) | Pri |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Add product with all valid required fields | ADMIN-01 | Admin is logged in and on /admin dashboard | 1. Click "Add Product" button 2. Fill form: Name="iPhone 15 Pro", Brand="Apple", Category="Smartphones", Price="99999", Rating="4.5", Image URL="https://example.com/iphone.jpg", Description="Latest flagship phone" 3. Click Save | Product created successfully; product appears in dashboard list; success message displayed; database contains new product with correct details; HTTP 201 response | | | | | High |
| 2 | Add product with minimum required fields | ADMIN-02 | Admin is on /admin dashboard | 1. Click "Add Product" 2. Fill only required fields: Name, Brand, Category, Price, Rating, Image URL 3. Leave Description empty 4. Click Save | Product saved successfully; appears in product list; all required fields stored in database; optional description field accepted as null/empty | | | | | High |
| 3 | Add product with special characters in name | ADMIN-03 | Admin is on /admin dashboard | 1. Add product with Name="Samsung Galaxy S24+ Ultra™" 2. Fill other required fields 3. Save | Product created; special characters preserved correctly; name displays properly in list; no encoding errors; UTF-8 characters handled correctly | | | | | Medium |
| 4 | Add product with decimal price | ADMIN-04 | Admin is on /admin dashboard | 1. Add product with Price="15999.99" 2. Fill other fields 3. Save | Product saved; price stored as decimal; displays correctly in product list and detail pages; pricing calculations work correctly | | | | | High |
| 5 | Add product with rating 1 (minimum) | ADMIN-05 | Admin is on /admin dashboard | 1. Add product with Rating="1" 2. Fill other required fields 3. Save | Product saved; rating value of 1 accepted; stored in database; displays correctly in UI | | | | | Medium |
| 6 | Add product with rating 5 (maximum) | ADMIN-06 | Admin is on /admin dashboard | 1. Add product with Rating="5" 2. Fill other required fields 3. Save | Product saved; rating value of 5 accepted; stored correctly; displays as 5-star rating in UI | | | | | Medium |

---

### 2. Add Product - Negative Scenarios & Validation

| Scenario TID | Scenario Description | Test Case ID | Pre Condition | Steps to Execute | Expected Result | Actual Result | Status | Executed QA Name | Misc (Comments) | Pri |
|---|---|---|---|---|---|---|---|---|---|---|
| 7 | Add product without name field | ADMIN-07 | Admin is on /admin dashboard with Add Product form open | 1. Leave Name field empty 2. Fill all other required fields 3. Click Save | Validation error: "Name is required"; product not created; form highlights empty field; user can correct and resubmit | | | | | High |
| 8 | Add product with negative price | ADMIN-08 | Admin is on /admin dashboard | 1. Add product with Price="-5000" 2. Fill other required fields 3. Save | Validation error: "Price must be 0 or greater"; product not created; negative prices rejected | | | | | High |
| 9 | Add product with rating below 1 | ADMIN-09 | Admin is on /admin dashboard | 1. Add product with Rating="0.5" 2. Fill other fields 3. Save | Validation error: "Rating must be between 1 and 5"; product not rejected with rating < 1 | | | | | High |
| 10 | Add product with rating above 5 | ADMIN-10 | Admin is on /admin dashboard | 1. Add product with Rating="5.5" 2. Fill other fields 3. Save | Validation error: "Rating must be between 1 and 5"; product not created; rating > 5 rejected | | | | | High |
| 11 | Add product with name exceeding 255 characters | ADMIN-11 | Admin is on /admin dashboard | 1. Enter Name with 256+ characters 2. Fill other fields 3. Save | Validation error: "Name may not be greater than 255 characters"; product not created | | | | | Medium |
| 12 | Add product without brand field | ADMIN-12 | Admin is on /admin dashboard with form open | 1. Leave Brand field empty 2. Fill other required fields 3. Save | Validation error: "Brand is required"; form rejects submission; user prompted to fill brand | | | | | High |

---

### 3. Edit Product - Positive Scenarios

| Scenario TID | Scenario Description | Test Case ID | Pre Condition | Steps to Execute | Expected Result | Actual Result | Status | Executed QA Name | Misc (Comments) | Pri |
|---|---|---|---|---|---|---|---|---|---|---|
| 13 | Edit product with valid updated data | ADMIN-13 | Admin is logged in; product with ID=1 exists (e.g., "iPhone 15") | 1. On /admin dashboard, find product "iPhone 15" 2. Click Edit button 3. Change Price from "99999" to "89999" 4. Change Description to "Updated flagship device" 5. Click Save | Product updated successfully; product list shows new price "89999"; database updated; success message displayed; HTTP 200 response; product details reflect changes | | | | | High |
| 14 | Edit product name and category | ADMIN-14 | Product exists in database | 1. Click Edit on a product 2. Change Name from "Samsung Galaxy S24" to "Samsung Galaxy S24 Ultra" 3. Change Category from "Smartphones" to "Premium Smartphones" 4. Save | Product updated; changes persisted in database and UI; related products and filters updated if necessary | | | | | High |
| 15 | Edit product to change rating | ADMIN-15 | Product with current rating="4.0" exists | 1. Edit product 2. Change Rating from "4.0" to "4.8" 3. Save | Rating updated in database; product list displays new rating; product details page reflects change | | | | | Medium |

---

### 4. Edit Product - Negative Scenarios

| Scenario TID | Scenario Description | Test Case ID | Pre Condition | Steps to Execute | Expected Result | Actual Result | Status | Executed QA Name | Misc (Comments) | Pri |
|---|---|---|---|---|---|---|---|---|---|---|
| 16 | Edit product with invalid product ID | ADMIN-16 | Admin is on /admin dashboard | 1. Try accessing API endpoint: PUT /api/admin/products/9999 (non-existent ID) with valid data 2. Submit request | Error response: HTTP 404 Not Found; "Product not found" message; product not updated; no orphaned records created | | | | | High |
| 17 | Edit product with blank required field | ADMIN-17 | Edit form is open for a product | 1. Clear the Name field completely 2. Try to save | Validation error: "Name is required"; changes not saved; original product name preserved | | | | | High |
| 18 | Edit product with price below 0 | ADMIN-18 | Product edit form is open | 1. Change Price to "-100" 2. Click Save | Validation error: "Price must be 0 or greater"; product not updated; original price maintained | | | | | High |

---

### 5. Delete Product - Positive Scenarios

| Scenario TID | Scenario Description | Test Case ID | Pre Condition | Steps to Execute | Expected Result | Actual Result | Status | Executed QA Name | Misc (Comments) | Pri |
|---|---|---|---|---|---|---|---|---|---|---|
| 19 | Delete product successfully | ADMIN-19 | Admin is logged in; product with ID=5 exists in database | 1. On /admin dashboard, find product 2. Click Delete button 3. Confirm deletion (if confirmation dialog appears) | Product deleted from database; product no longer appears in dashboard list; success message displayed; HTTP 200 with "Product deleted successfully"; product count decreases | | | | | High |
| 20 | Delete product removes all references | ADMIN-20 | Product with ID=7 exists; may be in shopping carts or wishlist | 1. Delete product 2. Verify it's removed from all locations | Product deleted; removed from product catalog, search results, and featured sections; no broken references; orphaned cart items handled gracefully | | | | | Medium |

---

### 6. Delete Product - Negative Scenarios

| Scenario TID | Scenario Description | Test Case ID | Pre Condition | Steps to Execute | Expected Result | Actual Result | Status | Executed QA Name | Misc (Comments) | Pri |
|---|---|---|---|---|---|---|---|---|---|---|
| 21 | Delete non-existent product ID | ADMIN-21 | Admin is on /admin dashboard | 1. Try API endpoint: DELETE /api/admin/products/99999 (non-existent) 2. Submit request | Error response: HTTP 404 Not Found; "Product not found" message; database unchanged; no side effects | | | | | High |
| 22 | Delete product without admin privileges | ADMIN-22 | Regular user (role='user') is authenticated | 1. Try accessing DELETE /api/admin/products/1 as regular user 2. Submit request | Access denied: HTTP 403 Forbidden; "Unauthorized access. Admin privileges required."; product not deleted; only admin can delete | | | | | High |

---

### 7. Admin Access Control & Security

| Scenario TID | Scenario Description | Test Case ID | Pre Condition | Steps to Execute | Expected Result | Actual Result | Status | Executed QA Name | Misc (Comments) | Pri |
|---|---|---|---|---|---|---|---|---|---|---|
| 23 | Regular user cannot access /admin dashboard | ADMIN-23 | Regular user is logged in with role='user' | 1. Login as regular user 2. Try accessing /admin page (direct URL) | HTTP 403 Forbidden error; message "Unauthorized access. Admin privileges required."; redirect or error page; user cannot see admin interface | | | | | High |
| 24 | Regular user cannot POST to add product API | ADMIN-24 | Regular user is logged in | 1. Try sending POST request to /api/admin/products with product data 2. Submit request | HTTP 403 Forbidden response; "Unauthorized access. Admin privileges required."; product not created; API protected by middleware | | | | | High |
| 25 | Regular user cannot PUT to edit product API | ADMIN-25 | Regular user is authenticated; product exists | 1. Try sending PUT request to /api/admin/products/1 with updated data 2. Submit | HTTP 403 Forbidden; edit not allowed; product unchanged; admin middleware blocks request | | | | | High |
| 26 | Regular user cannot DELETE product via API | ADMIN-26 | Regular user is authenticated | 1. Try sending DELETE request to /api/admin/products/1 2. Submit | HTTP 403 Forbidden response; "Unauthorized access. Admin privileges required."; product not deleted; only admin can delete | | | | | High |
| 27 | Unauthenticated user cannot perform admin actions | ADMIN-27 | User is NOT logged in | 1. Try accessing /admin page without login 2. Try accessing /api/admin/products endpoints | Redirect to /login page; unauthenticated users blocked from all admin routes; middleware enforces authentication | | | | | High |
| 28 | Admin middleware validates role before action | ADMIN-28 | User with role != 'admin' is logged in | 1. Login as user (not admin) 2. Try any admin action: GET /admin, POST/PUT/DELETE API 3. Attempt request | All requests rejected with 403 Forbidden; middleware checks isAdmin() method; role-based validation enforced at middleware level | | | | | High |

---

### 8. Full CRUD Integration & Edge Cases

| Scenario TID | Scenario Description | Test Case ID | Pre Condition | Steps to Execute | Expected Result | Actual Result | Status | Executed QA Name | Misc (Comments) | Pri |
|---|---|---|---|---|---|---|---|---|---|---|
| 29 | Complete CRUD cycle: Create → Read → Update → Delete | ADMIN-29 | Admin is logged in on /admin dashboard | 1. Create product: Name="Test Phone", Brand="TestBrand", Price=50000 2. Verify product appears in list 3. Edit product: change price to 45000 4. Verify change in list 5. Delete product 6. Verify product removed from list | All operations succeed sequentially; product created (GET/LIST works), editable with updates persisted (PUT works), and removable (DELETE works); full CRUD cycle functional | | | | | High |
| 30 | Add product with long description | ADMIN-30 | Admin is on /admin dashboard | 1. Add product with Description containing 500+ characters 2. Fill other required fields 3. Save | Product saved with full description; no truncation at 255 character limit (if nullable string type); description displays correctly in product details | | | | | Medium |
| 31 | Add multiple products rapidly | ADMIN-31 | Admin is on /admin dashboard | 1. Add Product A 2. Immediately add Product B (without waiting for response) 3. Add Product C 4. Verify all three in list | All three products created successfully; IDs unique and sequential; no race conditions; database integrity maintained; all products visible in list | | | | | Medium |
| 32 | Verify CSRF token protection on product operations | ADMIN-32 | Admin has active session with CSRF token | 1. Try making POST/PUT/DELETE request without CSRF token 2. Submit form with invalid/missing token | Request rejected: HTTP 419 Token Mismatch or 403 error; CSRF protection active; forms include hidden _token field; API requests include token in header | | | | | High |

---

## TEST EXECUTION SUMMARY

| Module | Total Cases | Positive Cases | Negative Cases | Edge Cases | High Priority | Medium Priority | Low Priority |
|---|---|---|---|---|---|---|---|
| Authentication (AUTH) | 22 | 13 | 7 | 2 | 17 | 4 | 1 |
| Admin Dashboard (ADMIN) | 32 | 15 | 11 | 6 | 24 | 7 | 1 |
| **TOTAL** | **54** | **28** | **18** | **8** | **41** | **11** | **2** |

---

## NOTES FOR QA TEAM

### Authentication Testing

1. **Session Management**: Use browser DevTools (Application/Storage tab) to verify session cookies are created on login and cleared on logout.

2. **Password Security**: Verify passwords are hashed using Laravel's Hash::make() and stored as hashes in database (never plain text).

3. **Remember Me**: Test by logging out completely, closing browser, and returning to site to verify auto-login works.

4. **Email Validation**: Test with various formats:
   - Valid: user@example.com, user.name@example.co.uk
   - Invalid: userexample.com, user@.com, @example.com

5. **CSRF Protection**: All forms should include `{{ csrf_token() }}` or CSRF middleware should be active.

---

### Admin Dashboard Testing

1. **Database State**: Ensure test database contains:
   - At least 1 admin user (role='admin')
   - At least 1 regular user (role='user')
   - 5-10 sample products for editing/deleting tests

2. **Middleware Validation**:
   - Auth middleware: user must be logged in
   - Admin middleware: user must have role='admin'
   - Both checked before action permitted

3. **API Responses**:
   - POST /api/admin/products (201 Created with product data)
   - PUT /api/admin/products/{id} (200 OK with updated product)
   - DELETE /api/admin/products/{id} (200 OK with success message)
   - All errors return appropriate HTTP status codes (403, 404, 422)

4. **Validation Rules**:
   - Name: required, string, max:255
   - Brand: required, string, max:255
   - Category: required, string, max:255
   - Price: required, numeric, min:0
   - Rating: required, numeric, min:1, max:5
   - Image: required, string
   - Description: nullable, string

5. **JSON Responses**:
   - Success: { "id": 1, "name": "...", "brand": "...", ... }
   - Error: { "message": "...", "errors": { "field": ["error message"] } }

---

### Security & Compliance

1. **Role-Based Access**: Regular users must NOT access:
   - GET /admin (returns 403)
   - POST /api/admin/products (returns 403)
   - PUT /api/admin/products/{id} (returns 403)
   - DELETE /api/admin/products/{id} (returns 403)

2. **SQL Injection Prevention**: Test with inputs like:
   - Name: "'; DROP TABLE products; --"
   - Input should be sanitized and stored as literal string

3. **Session Security**:
   - Session ID changes after login ($request->session()->regenerate())
   - Session invalidated on logout ($request->session()->invalidate())
   - CSRF token regenerated ($request->session()->regenerateToken())

4. **Password Requirements**:
   - Minimum 8 characters (enforced in validation)
   - Must be confirmed (password_confirmation must match password)
   - Hashed before storage in database

---

### Browser Compatibility

- Test on Chrome, Firefox, Safari, Edge
- Test on mobile browsers (iOS Safari, Android Chrome)
- Verify responsive forms work on all devices

---

### Performance Considerations

- Login should complete in < 1 second
- Product CRUD operations should respond in < 2 seconds
- Dashboard should load with 10+ products in < 3 seconds

---

**Document Version:** 1.0  
**Last Updated:** April 30, 2026  
**Prepared By:** QA Team
