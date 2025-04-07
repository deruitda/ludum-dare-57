extends Node

# Gameplay Signals
signal new_game()
signal player_has_won()

# Money Collected Signals
signal add_money_collected(moneyPaid: int)
signal money_collected_updated()

# Cargo Signals
signal add_cargo(tile_resource: ValuableTileResource)
signal cargo_updated()
signal cargo_at_max_capacity()
signal sell_cargo()

# Hull Signals
signal hull_health_updated(hull: Hull)
signal hull_destroyed()

# Resources
signal resource_pinged(coords: Vector2, tile_resource: TileResource)

# Status Signals
signal set_current_depth(depth: float)
signal set_normalized_depth_percentage(depth: float)

# Battery Signals
signal battery_updated(battery: Battery)
signal submarine_lost_power()

# Submarine Signals
signal toggle_flashlight()
signal ping_sonar()

# Shop Signals
signal close_shop()
signal open_shop()
signal player_entered_shop_area()
signal player_exited_shop_area()
signal purchase_upgrade(shop_item_resource: ShopItemResource)
signal purchase_completed(updated_shop_item_resource: ShopItemResource)
