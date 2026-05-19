# Airport Transfer Booking App — Flutter

## Overview

A mobile airport transfer booking app (modeled after "Melita Travel") with a 5-step booking flow: Home → Results → Add-ons → Information & Payment → Confirmation.

---

## Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: Riverpod (code generation variant)
- **Navigation**: go_router
- **HTTP**: Dio + Retrofit
- **Local Storage**: Hive or shared_preferences
- **Forms**: reactive_forms
- **Date/Time Picker**: omni_datetime_picker or cupertino_date_picker
- **Icons**: Material Icons + custom SVG assets (flutter_svg)

---

## Project Structure

```
lib/
  core/
    theme/
      app_theme.dart        # Colors, text styles, button themes
    router/
      app_router.dart       # go_router route definitions
    widgets/
      app_bottom_nav.dart   # Shared bottom navigation bar
  features/
    home/
    results/
    addons/
    payment/
    confirmation/
  models/
```

Each feature folder follows:
```
feature/
  presentation/
    screens/
    widgets/
  providers/        # Riverpod providers
  models/
```

---

## Theme & Design System

### Colors
- **Primary Blue**: `#1A73E8` (buttons, selected states, links)
- **Dark Navy**: `#1A1A2E` (hero banner background)
- **Background**: `#F5F7FA`
- **White**: `#FFFFFF` (cards)
- **Text Primary**: `#1A1A1A`
- **Text Secondary**: `#6B7280`
- **Success Green**: `#34D399`
- **Best Seller Badge**: `#1A73E8` (blue pill)
- **Border**: `#E5E7EB`

### Typography
- Font family: Inter or SF Pro (system default via `fontFamily: null`)
- Title large: 22sp, bold
- Body: 14sp, regular
- Caption: 12sp, medium
- Price: 18sp, bold

### Shared Widgets
- `AppBottomNavBar` — 5 tabs: Home, My Trips, Deals, Support, More
- `PrimaryButton` — full-width, blue, 48px height, 8px border radius
- `OutlinedCard` — white card with 1px border, 12px border radius, subtle shadow
- `SectionHeader` — label + optional "View all" link

---

## Screen 1 — Airport Transfers Home

**Route**: `/`

### Layout (top to bottom)
1. **AppBar**: Hamburger icon (left), Melita Travel logo (center), notification bell (right)
2. **Top Action Row**: "My Bookings" dropdown (left), "Call 24/7 Toll Free +1 416-767-8000" (right, blue text)
3. **Category Scroll Row**: horizontal scroll of icon+label tiles — Flight, Hotel, Car Rental, **Airport Transfers** (active/underlined in blue), Packages, More
4. **Hero Banner**: full-width image carousel (airport/car photo) with overlay text "Smooth Transfers, Every Time / Reliable airport transfers at the best prices" + page indicator dots
5. **Search Form Card** (white card, rounded):
   - Transfer Type: radio group — `One-way` | `Round-trip`
   - **From** field: plane icon + "Airport" label + text input (pre-filled: "New York (JFK)") + clear X
   - **To** field: location pin icon + "Destination" label + text input (pre-filled: "Manhattan, New York, USA") + clear X
   - **Pickup Date & Time**: calendar icon + date text + clock icon + time text (side by side)
   - **Passengers**: people icon + "2 Adults, 2 Suitcases" + chevron right
   - **Search Transfers** button (full-width, blue, search icon)
6. **Features Row**: 4 icon+label items in a row — Meet & Greet Driver, Free Waiting Time, Flight Tracking Included, 24/7 Support, Free Cancellation (scroll if overflow)
7. **Popular Routes** section:
   - Header: "Popular Routes" + "View all >"
   - 3 route cards: "JFK Airport → Manhattan From US$ 45", "LGA Airport → Manhattan From US$ 40", "EWR Airport → Manhattan From US$ 50"

---

## Screen 2 — Transfer Results

**Route**: `/results`

### AppBar
- Back arrow (left), route title "New York (JFK) → Manhattan", "Edit" text button (right, blue)
- Subtitle: "May 28, 2024 at 10:00 AM • 2 Adults"

### Filter Row
- "Sort: Recommended" dropdown (left)
- "Filter: All Filters" dropdown (right)

### Info Banner
- Blue info icon + "All prices are per vehicle, one-way transfer"

### Vehicle List (scrollable)
Each card (`OutlinedCard`) contains:
- **Badge**: "Best Seller" (blue pill, only on first card)
- **Favorite icon** (heart outline, top right)
- **Vehicle image** (left, ~80×60px)
- **Vehicle name** (bold): Sedan, MPV, SUV, Premium Van, Luxury Van
- **Capacity**: luggage icon + number, person icon + number
- **Features**: bullet list — "Meet & Greet", "60 mins Free Waiting"
- **Price** (right, bold): US$ 55 / Total US$ 55
- **Select button** (blue, right-aligned)

Vehicle list:
| Vehicle | Passengers | Luggage | Price |
|---|---|---|---|
| Sedan | 1–3 | 2 pax / 2 bags | US$ 55 |
| MPV | 4 | 4 pax / 3 bags | US$ 75 |
| SUV | 4–5 | 5 pax / 4 bags | US$ 95 |
| Premium Van | 6–8 | 8 pax / 8 bags | US$ 130 |
| Luxury Van | 6–7 | 7 pax / 7 bags | US$ 160 |

### Bottom Summary Bar (sticky)
- "Transfer Price: US$ 55.00"
- "Add-ons: US$ 20.00"
- "Total (1 Vehicle): US$ 75.00"
- "Continue" button (white text on dark navy background card)

### Footer Note
- Green checkmark + "Free Cancellation — Cancel up to 24 hours before your transfer" + "Know more >"

---

## Screen 3 — Add-ons

**Route**: `/addons`

### AppBar
- Back arrow, title "Add-ons", route + date + passengers subtitle

### Section 1 — Protection & Insurance
Header: "Protection & Insurance / Add protection for a stress-free journey"

Items (checkbox + label + info icon + price):
- ✅ Cancellation Insurance — Get refund for eligible cancellations — **US$ 12.00** (pre-checked)
- ✅ Health Insurance — Coverage for medical emergencies — **US$ 8.00** (pre-checked)

### Section 2 — Convenience
- Extra Waiting Time (clock icon) — Additional waiting time for driver — **US$ 15.00 / 30 mins**
- Meet & Greet (person icon) — Driver will meet you at arrivals — **Included** (green, no price)

### Section 3 — Other Add-ons
- Child Seat (unchecked) — For children 1–7 years — **US$ 10.00**
- Additional Stop (unchecked) — Add a stop en-route — **US$ 15.00**
- Return Transfer (unchecked) — Book your return transfer — **US$ 50.00**

### Bottom Bar (sticky dark card)
- "Transfer Price: US$ 55.00"
- "Add-ons: US$ 20.00"
- "Total (1 Vehicle): **US$ 75.00**"
- "Continue" button

---

## Screen 4 — Information & Payment

**Route**: `/payment`

### AppBar
- Back arrow, "Information & Payment", route + date + passengers subtitle

### Section — Contact Information
Form fields:
- Full Name (text input, pre-filled "John Smith")
- Email (email input, pre-filled "john.smith@email.com")
- Phone Number (phone input with country code, "+1 416-555-1234")

### Section — Transfer Details
- "Edit" link (top right, blue)
- From: "John F. Kennedy International Airport (JFK)"
- To: "Manhattan, New York, USA"
- Date & Time: "Wed, May 28, 2024 at 10:00 AM"
- Passengers: "2 Adults"
- Vehicle Type: "Sedan (1-3 Passengers)"

### Section — Payment Method
- Lock icon + "Your payment is secure"
- Radio group:
  - ✅ Credit / Debit Card (Visa + Mastercard + Amex logos)
  - PayPal (PayPal logo)
  - Apple Pay (Apple Pay logo)

### Section — Price Details
- Transfer Price (Sedan): US$ 55.00
- Add-ons (2): US$ 20.00
- Taxes & Fees: US$ 8.00
- **Total Amount: US$ 83.00** (bold, larger)

### CTA
- "Pay Now" button (full-width, blue)
- "You can cancel for free before May 27, 2024" (caption, centered, gray)

---

## Screen 5 — Confirmation

**Route**: `/confirmation`

### Layout (centered, no AppBar scrollable)
1. Confetti / celebration illustration (top, colored dots)
2. Green circle checkmark icon (large, ~80px)
3. **"Your booking is confirmed!"** (title, bold)
4. "We have sent the booking details to john.smith@email.com" (subtitle, gray)
5. **Booking Reference**: "TRF12345678" + copy icon (blue pill/card)

### Booking Summary Card
- From → To: "JFK Airport → Manhattan"
- Date: "Wed, May 28, 2024 at 10:00 AM"
- Vehicle image (right)
- Vehicle: Sedan
- Passengers: 2 Adults
- **Total Paid: US$ 83.00**

### Add-ons Included (green checkmarks)
- Cancellation Insurance
- Health Insurance
- Extra Waiting Time (30 mins)
- Child Seat

### Action Buttons
- "View My Booking" (full-width, blue)
- "Download Voucher" (outlined, left half) | "Share" (outlined, right half) — side by side
- "Back to Home" (text button, centered)

---

## Navigation

Bottom navigation bar (always visible on Home; hidden or shown depending on screen):
| Tab | Icon | Label |
|---|---|---|
| 0 | home | Home |
| 1 | luggage | My Trips |
| 2 | local_offer | Deals |
| 3 | headset_mic | Support |
| 4 | more_horiz | More |

Active tab color: Primary Blue. Inactive: gray.

The booking flow (Results → Add-ons → Payment → Confirmation) uses full-screen routes and hides the bottom nav.

---

## Data Models

```dart
class TransferSearch {
  final TransferType type; // oneWay | roundTrip
  final String fromAirport;
  final String toDestination;
  final DateTime pickupDateTime;
  final int adults;
  final int suitcases;
}

class VehicleOption {
  final String id;
  final String name;
  final int maxPassengers;
  final int maxLuggage;
  final double price;
  final List<String> features;
  final bool isBestSeller;
  final String imageAsset;
}

class Addon {
  final String id;
  final String title;
  final String description;
  final double price; // 0 = included
  final AddonCategory category;
  bool selected;
}

class BookingContact {
  final String fullName;
  final String email;
  final String phone;
}

class Booking {
  final String reference;
  final TransferSearch search;
  final VehicleOption vehicle;
  final List<Addon> addons;
  final BookingContact contact;
  final double totalAmount;
  final PaymentMethod paymentMethod;
}
```

---

## State (Riverpod)

```dart
// Search form state
final transferSearchProvider = StateNotifierProvider<TransferSearchNotifier, TransferSearch>

// Available vehicles (async fetch)
final vehicleResultsProvider = FutureProvider.family<List<VehicleOption>, TransferSearch>

// Selected vehicle
final selectedVehicleProvider = StateProvider<VehicleOption?>

// Selected add-ons
final selectedAddonsProvider = StateNotifierProvider<AddonsNotifier, List<Addon>>

// Contact info
final contactInfoProvider = StateProvider<BookingContact?>

// Current booking (post-payment)
final confirmedBookingProvider = StateProvider<Booking?>
```

---

## Routing (go_router)

```dart
final router = GoRouter(routes: [
  GoRoute(path: '/', builder: (_, __) => HomeScreen()),
  GoRoute(path: '/results', builder: (_, __) => ResultsScreen()),
  GoRoute(path: '/addons', builder: (_, __) => AddonsScreen()),
  GoRoute(path: '/payment', builder: (_, __) => PaymentScreen()),
  GoRoute(path: '/confirmation', builder: (_, __) => ConfirmationScreen()),
]);
```

---

## Assets

Place under `assets/`:
```
assets/
  images/
    hero_banner_1.jpg
    vehicle_sedan.png
    vehicle_mpv.png
    vehicle_suv.png
    vehicle_premium_van.png
    vehicle_luxury_van.png
    logo_visa.png
    logo_mastercard.png
    logo_amex.png
    logo_paypal.png
    logo_applepay.png
  icons/
    ic_meet_greet.svg
    ic_flight_tracking.svg
```

---

## pubspec.yaml Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  go_router: ^13.0.0
  dio: ^5.4.0
  retrofit: ^4.1.0
  hive_flutter: ^1.1.0
  reactive_forms: ^17.0.0
  flutter_svg: ^2.0.10
  intl: ^0.19.0
  omni_datetime_picker: ^2.0.4
  cached_network_image: ^3.3.1

dev_dependencies:
  build_runner: ^2.4.8
  riverpod_generator: ^2.3.10
  retrofit_generator: ^8.1.0
  hive_generator: ^2.0.1
```

---

## Build & Run

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

---

## Coding Conventions

- All widgets in their own files under the relevant feature's `widgets/` folder
- No business logic in `build()` methods — use providers
- Use `const` constructors wherever possible
- Extract repeated padding/spacing into theme constants
- All monetary values formatted with `NumberFormat.currency(symbol: 'US\$ ', decimalDigits: 2)`
- Dates formatted with `DateFormat('EEE, MMM d, yyyy')`
