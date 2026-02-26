# Allow repeated trigger of set_item advancement.
advancement revoke @s only synthesizer:utilities/set_item

# Find tuners with an item within placement range of the player. Only one should match this criteria as they are broken after the item is set.
execute as @e[type=minecraft:glow_item_frame, distance=0..10, nbt={data: {synthesizer: {is_tuner: true}}}] if data entity @s Item run tag @s add synthesizer_set_item_active

# Stop execution if the tuner is not placed on a synthesizer.
execute as @n[tag=synthesizer_set_item_active] at @s unless data block ^ ^ ^-1 components."minecraft:custom_data".synthesizer.is_synthesizer run return fail

# Reset item data in the synthesizer.
execute as @n[tag=synthesizer_set_item_active] at @s if data block ^ ^ ^-1 SpawnData.entity.Item run data modify block ^ ^ ^-1 SpawnData.entity set value {}

# Set new item in the synthesizer. Alway enforce a count of 1.
execute as @n[tag=synthesizer_set_item_active] at @s run data modify block ^ ^ ^-1 SpawnData.entity.id set value "minecraft:item"
execute as @n[tag=synthesizer_set_item_active] at @s run data modify block ^ ^ ^-1 SpawnData.entity.Item.count set value 1
execute as @n[tag=synthesizer_set_item_active] at @s run data modify block ^ ^ ^-1 SpawnData.entity.Item.id set from entity @s Item.id
execute as @n[tag=synthesizer_set_item_active] at @s run data modify block ^ ^ ^-1 SpawnData.entity.Item.components set from entity @s Item.components

# Inform the player of success.
execute if entity @n[tag=synthesizer_set_item_active] run title @s actionbar {type: "text", text: "Synthesizer item set!", color: "green"}

# Damange the tuner twice. First time removes the item, second time breaks the tuner.
execute as @n[tag=synthesizer_set_item_active] run damage @s 0 minecraft:generic
execute as @n[tag=synthesizer_set_item_active] run damage @s 0 minecraft:generic
