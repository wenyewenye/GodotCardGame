extends Node

enum LOGLEVEL {SYSTEM=0,TURN,ATTACK=2,SUPERATTACK=4,RESPONSE,LITE,NONE}
@warning_ignore("unused_signal")
signal card_tip_show(card:Card)
@warning_ignore("unused_signal")
signal card_tip_hide
@warning_ignore("unused_signal")
signal setlog(text: String, level:LOGLEVEL)
@warning_ignore("unused_signal")
signal set_store_data(text: String)
