extends Node

# Money Collected Signals
signal add_money_collected(moneyPaid: int)
signal money_collected_updated()

# Cargo Signals
signal add_cargo(tile_resource: ValuableTileResource)
signal cargo_updated()
signal cargo_at_max_capacity()
signal sell_cargo()

# Player Signals
signal player_health_changed(new_health_value: int)
signal submarine_destroyed()
signal resource_pinged(coords: Vector2, tile_resource: TileResource)

# Status Signals
signal set_current_depth(depth: float)
signal set_normalized_depth_percentage(depth: float)

# Shop Signals
signal purchase_upgrade(shop_item_resource: ShopItemResource)
signal purchase_completed(updated_shop_item_resource: ShopItemResource)
