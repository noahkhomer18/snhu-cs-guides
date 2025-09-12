# CS-250 Agile User Stories

## 🎯 Purpose
Demonstrate proper user story creation and acceptance criteria for Agile development.

## 📝 User Story Examples

### E-commerce Website User Stories

#### Epic: User Authentication
```
As a customer
I want to create an account
So that I can save my preferences and order history

Acceptance Criteria:
- User can register with email and password
- System validates email format
- Password must be at least 8 characters
- User receives confirmation email
- Account is created and user is logged in
```

#### Epic: Product Catalog
```
As a customer
I want to browse products by category
So that I can find items I'm interested in

Acceptance Criteria:
- Products are organized by categories
- User can filter by price range
- User can sort by price, rating, or name
- Product images and descriptions are displayed
- Pagination works for large product lists
```

#### Epic: Shopping Cart
```
As a customer
I want to add items to my cart
So that I can purchase multiple items together

Acceptance Criteria:
- User can add items to cart from product page
- Cart shows item count and total price
- User can modify quantities in cart
- User can remove items from cart
- Cart persists between sessions when logged in
```

### Mobile App User Stories

#### Epic: Location Services
```
As a user
I want to find nearby restaurants
So that I can discover new dining options

Acceptance Criteria:
- App requests location permission
- Shows restaurants within 5-mile radius
- Displays restaurant ratings and reviews
- Provides directions to selected restaurant
- Works offline with cached data
```

#### Epic: Social Features
```
As a user
I want to share my check-ins
So that my friends can see where I've been

Acceptance Criteria:
- User can check in at locations
- Check-ins are posted to their profile
- Friends can see check-ins in their feed
- User can add photos to check-ins
- Privacy settings control who can see check-ins
```

## 🔍 User Story Best Practices

### INVEST Criteria
- **Independent**: Story can be developed independently
- **Negotiable**: Details can be discussed and refined
- **Valuable**: Provides value to the user or business
- **Estimable**: Team can estimate effort required
- **Small**: Can be completed in one sprint
- **Testable**: Has clear acceptance criteria

### Story Template
```
As a [user type]
I want [functionality]
So that [benefit/value]

Acceptance Criteria:
- [Specific, testable condition]
- [Another specific condition]
- [Edge case or error handling]
```

## 💡 Learning Points
- User stories focus on user value, not technical implementation
- Acceptance criteria must be specific and testable
- Stories should be small enough for one sprint
- Include edge cases and error scenarios
