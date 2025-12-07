# Provider Azure
provider "azurerm" {
  features {}
}

# Grupa zasobów
resource "azurerm_resource_group" "rg" {
  name     = "myResourceGroup"
  location = "polandcentral" # Twoja dozwolona lokalizacja
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "mynestappacr"   # musi być globalnie unikalna
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"       # Basic, Standard lub Premium
  admin_enabled       = true              # ułatwia logowanie (do testów)
}