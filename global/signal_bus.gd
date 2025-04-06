extends Node

# Money Collected Signals
signal add_money_collected(moneyPaid: int)
signal money_collected_updated()

# Cargo Signals
signal add_cargo()
signal cargo_updated()
signal cargo_at_max_capacity()
signal sell_cargo()

# Player Signals
signal player_health_changed(new_health_value: int)
signal resource_pinged(coords: Vector2, tile_resource: TileResource)

signal set_current_depth(depth: float)
