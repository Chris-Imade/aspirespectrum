#!/bin/bash

# Create backup directory if it doesn't exist
mkdir -p services_backup

# Define the list of service pages
services=(
  "autism-and-behavioral-services.html"
  "daily-living-adaptive-skills.html"
  "early-intervention.html"
  "evidence-based-therapy.html"
  "expressive-receptive-language.html"
  "functional-communication-training.html"
  "social-skills.html"
  "verbal-communication.html"
)

# Create backup of all service pages
for service in "${services[@]}"; do
  if [ -f "services/$service" ]; then
    cp "services/$service" "services_backup/$service.bak"
    echo "Backed up $service"
  fi
done

# Function to update a service page
update_service_page() {
  local file="services/$1"
  local service_name="${1%.html}"
  service_name="${service_name//-/ }"
  service_name=$(echo "$service_name" | awk '{for(i=1;i<=NF;i++){$i=toupper(substr($i,1,1)) tolower(substr($i,2))} print}')
  
  # Update breadcrumb
  sed -i '' '/<div class="breadcrumb-wrapper z-index-common overflow-hidden">/,/<\/div>/c\
  <div class="breadcrumb-wrapper z-index-common overflow-hidden" style="background-color: #7FC780;">\
    <div class="container">\
      <div class="breadcrumb-wrapper__content wow animate__fadeInUp" data-wow-delay="0.45s">\
        <h1 class="breadcrumb-wrapper__title" style="color: #ffffff;">'"$service_name"'</h1>\
        <div class="breadcrumb-wrapper__menu--wrap">\
          <ul class="breadcrumb-wrapper__menu">\
            <li class="breadcrumb-wrapper__menu--item">\
              <a href="../index.html" style="color: #ffffff;">Home</a>\
            </li>\
            <li class="breadcrumb-wrapper__menu--item">\
              <a href="../services.html" style="color: #ffffff;">Services</a>\
            </li>\
            <li class="breadcrumb-wrapper__menu--item" style="color: rgba(255, 255, 255, 0.8);">'"$service_name"'</li>\
          </ul>\
        </div>\
      </div>\
    </div>\
    <div class="vs-balls vs-balls--screen" data-balls-bottom="-6px" data-balls-color="#ffffff"></div>\
  </div>' "$file"
  
  # Update section padding
  sed -i '' 's/<section class="space space-extra-bottom">/<section class="space space-extra-bottom" style="padding: 80px 0;">/g' "$file"
  
  # Update styles
  sed -i '' '/<style>/,/<\/style>/c\
  <style>\
    .vs-header__logo>a>.logo {\
      height: 110px;\
    }\
    \
    /* Section Headings */\
    .vs-title__main {\
      color: #7FC780;\
      margin-bottom: 30px;\
    }\
    \
    .vs-title__sub {\
      color: #7FC780;\
      font-weight: 600;\
      margin-bottom: 15px;\
      display: block;\
    }\
    \
    /* Service Hero */\
    .service-hero {\
      border-radius: 12px;\
      overflow: hidden;\
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);\
      margin-bottom: 30px;\
    }\
    \
    .service-hero img {\
      width: 100%;\
      height: 400px;\
      object-fit: cover;\
      transition: transform 0.5s ease;\
    }\
    \
    .service-hero:hover img {\
      transform: scale(1.02);\
    }\
    \
    /* Content Styling */\
    .service-content {\
      line-height: 1.8;\
      color: #555;\
    }\
    \
    .service-content h2, \
    .service-content h3, \
    .service-content h4 {\
      color: #1a1a1a;\
      margin: 30px 0 15px;\
    }\
    \
    .service-content p {\
      margin-bottom: 20px;\
    }\
    \
    .service-content ul, \
    .service-content ol {\
      margin-bottom: 20px;\
      padding-left: 20px;\
    }\
    \
    .service-content li {\
      margin-bottom: 10px;\
    }\
  </style>' "$file"
  
  echo "Updated $1"
}

# Update all service pages
for service in "${services[@]}"; do
  if [ -f "services/$service" ]; then
    update_service_page "$service"
  fi
done

echo "\nAll service pages have been updated. Backups are available in the 'services_backup' directory."
