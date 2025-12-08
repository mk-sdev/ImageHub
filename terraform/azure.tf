provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-imagehub"
  location = "polandcentral"
}

resource "azurerm_container_registry" "acr" {
  name                = "imagehubacr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_container_group" "app" {
  name                = "imagehub-group"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"

  ip_address_type = "Public"
  dns_name_label  = "nest-app-demo-1234"

  container {
    name   = "app"
    image  = "${azurerm_container_registry.acr.login_server}/nest-app:latest"
    cpu    = "1"
    memory = "1.5"

    ports {
      port     = 3000
      protocol = "TCP"
    }

    environment_variables = {
      NODE_ENV = "production"
      MONGO_URI = "mongodb://localhost:27017/mydb"
      AMQP_URL  = "amqp://guest:guest@localhost:5672"
    }
  }

  container {
    name   = "mongo"
    image  = "mongo:6.0"
    cpu    = "1"
    memory = "1.5"

    ports {
      port     = 27017
      protocol = "TCP"
    }
  }

  container {
    name   = "rabbitmq"
    image  = "rabbitmq:3-management"
    cpu    = "1"
    memory = "1.5"

    ports {
      port     = 5672
    }

    ports {
      port     = 15672
    }
  }

  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }
}