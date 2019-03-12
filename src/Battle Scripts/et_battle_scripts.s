.text
.thumb
.align 2

.include "..\\defines"

.global BattleScript_MysteriousAirCurrentContinues
.global BattleScript_FogEnded
.global BattleScript_FogContinues
.global BattleScript_SeaOfFireDamage
.global BattleScript_GrassyTerrainHeal
.global BattleScript_Healer
.global BattleScript_AquaRing
.global BattleScript_PoisonHeal
.global BattleScript_MagnetRiseEnd
.global BattleScript_TelekinesisEnd
.global BattleScript_HealBlockEnd
.global BattleScript_EmbargoEnd
.global BattleScript_AuroraVeilEnd
.global BattleScript_TailwindEnd
.global BattleScript_LuckyChantEnd
.global BattleScript_RainbowEnd
.global BattleScript_SeaOfFireEnd
.global BattleScript_SwampEnd
.global BattleScript_TrickRoomEnd
.global BattleScript_WaterSportEnd
.global BattleScript_MudSportEnd
.global BattleScript_WonderRoomEnd
.global BattleScript_MagicRoomEnd
.global BattleScript_GravityEnd
.global BattleScript_TerrainEnd
.global BattleScript_MoodyRegular
.global BattleScript_MoodySingleStat
.global BattleScript_BadDreams
.global BattleScript_ToxicOrb
.global BattleScript_FlameOrb
.global BattleScript_Harvest
.global BattleScript_Pickup
.global BattleScript_ZenMode
.global BattleScript_PowerConstruct
.global BattleScript_StartedSchooling
.global BattleScript_StoppedSchooling
.global BattleScript_ShieldsDownToCore
.global BattleScript_ShieldsDownToMeteor
.global BattleScript_FlowerGift
.global BattleScript_MonTookFutureAttack
.global BattleScript_PrintCustomStringEnd3

.global TrickRoomEndString
.global WonderRoomEndString
.global MagicRoomEndString
.global GravityEndString
.global TerrainEndString
.global TransformedString

.global BattleScript_Victory @More of an "End Battle" BS but whatever
.global BattleScript_PrintPlayerForfeited
.global BattleScript_PrintPlayerForfeitedLinkBattle
.global BattleScript_LostMultiBattleTower
.global BattleScript_LostBattleTower

.global AbilityActivatedString

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@0x80159DC with r0
EndBattleFlagClearHook: @Not really a BS but whatever
	bl EndOfBattleThings
	ldr r1, .BattleMainFunc
	ldr r0, .CallbackReturnToOverworld
	str r0, [r1]
	ldr r1, .SomeFutureC2
	ldr r0, .EndBattleFlagClearHookReturn
	bx r0

.align 2
.BattleMainFunc: .word 0x3004F84
.CallbackReturnToOverworld: .word 0x8015A30 | 1
.SomeFutureC2: .word 0x300537C
.EndBattleFlagClearHookReturn: .word 0x80159E4 | 1

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_MysteriousAirCurrentContinues:
	setword BATTLE_STRING_LOADER MysteriousAirCurrentContinuesString
	printstring 0x184
	waitmessage DELAY_1SECOND
	playanimation 0x0 ANIM_STRONG_WINDS_CONTINUE 0x0
	end2

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_FogEnded:
	setword BATTLE_STRING_LOADER FogEndedString
	printstring 0x184
	waitmessage DELAY_1SECOND
	end2

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_FogContinues:
	setword BATTLE_STRING_LOADER FogContinuesString
	printstring 0x184
	waitmessage DELAY_1SECOND
	playanimation 0x0 ANIM_FOG_CONTINUES 0x0
	end2

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_SeaOfFireDamage:
	callasm SeaOfFireDamageASM+1
	playanimation BANK_ATTACKER ANIM_SEA_OF_FIRE 0x0
	orword HIT_MARKER 0x100
	graphicalhpupdate BANK_ATTACKER
	datahpupdate BANK_ATTACKER
	setword BATTLE_STRING_LOADER SeaOfFireDamageString
	printstring 0x184
	waitmessage DELAY_1SECOND
	faintpokemon BANK_ATTACKER 0x0 0x0
	end2

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_GrassyTerrainHeal:
	callasm GrassyTerrainHeal+1
	playanimation BANK_ATTACKER ANIM_GRASSY_TERRAIN_HEAL 0x0
	orword HIT_MARKER 0x100
	graphicalhpupdate BANK_ATTACKER
	datahpupdate BANK_ATTACKER
	setword BATTLE_STRING_LOADER GrassyTerrainHealString
	printstring 0x184
	waitmessage DELAY_1SECOND
	end2

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_AquaRing:
	playanimation BANK_ATTACKER ANIM_AQUA_RING_HEAL 0x0
	orword HIT_MARKER 0x100
	graphicalhpupdate BANK_ATTACKER
	datahpupdate BANK_ATTACKER
	setword BATTLE_STRING_LOADER AquaRingHealString
	printstring 0x184
	waitmessage DELAY_1SECOND
	end2

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_PoisonHeal:
	playanimation BANK_ATTACKER ANIM_HEALING_SPARKLES 0x0
	orword HIT_MARKER 0x100
	graphicalhpupdate BANK_ATTACKER
	datahpupdate BANK_ATTACKER
	setword BATTLE_STRING_LOADER PoisonHealString
	printstring 0x184
	waitmessage DELAY_1SECOND
	end2

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_MagnetRiseEnd:
	clearspecialstatusbit BANK_ATTACKER STATUS3_LEVITATING
	setword BATTLE_STRING_LOADER MagnetRiseEndString
	printstring 0x184
	waitmessage DELAY_1SECOND
    end2

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_TelekinesisEnd:
	clearspecialstatusbit BANK_ATTACKER STATUS3_TELEKINESIS
	setword BATTLE_STRING_LOADER TelekinesisStringEndString
	printstring 0x184
	waitmessage DELAY_1SECOND
    end2

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_HealBlockEnd:
	setword BATTLE_STRING_LOADER HealBlockEndString
	printstring 0x184
	waitmessage DELAY_1SECOND
	end2

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_EmbargoEnd:
	setword BATTLE_STRING_LOADER EmbargoEndString
	printstring 0x184
	waitmessage DELAY_1SECOND
	end2

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_AuroraVeilEnd:
	jumpifbyte ANDS USER_BANK 0x1 FoeAuroraVeil
	
YourAuroraVeil:
	setword BATTLE_STRING_LOADER PlayerAuroraVeilEndString
	goto PrintTimerString

FoeAuroraVeil:
	setword BATTLE_STRING_LOADER FoeAuroraVeilEndString
	goto PrintTimerString

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_TailwindEnd:
	jumpifbyte ANDS USER_BANK 0x1 FoeTailwind

YourTailwind:
	setword BATTLE_STRING_LOADER PlayerTailwindEndString
	goto PrintTimerString

FoeTailwind:
	setword BATTLE_STRING_LOADER FoeTailwindEndString
	goto PrintTimerString

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_LuckyChantEnd:
	jumpifbyte ANDS USER_BANK 0x1 FoeLuckyChant

YourLuckyChant:
	setword BATTLE_STRING_LOADER PlayerLuckyChantEndString
	goto PrintTimerString

FoeLuckyChant:
	setword BATTLE_STRING_LOADER FoeLuckyChantEndString
	goto PrintTimerString

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_RainbowEnd:
	jumpifbyte ANDS USER_BANK 0x1 FoeRainbow

YourRainbow:
	setword BATTLE_STRING_LOADER PlayerRainbowEndString
	goto PrintTimerString

FoeRainbow:
	setword BATTLE_STRING_LOADER FoeRainbowEndString
	goto PrintTimerString

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_SeaOfFireEnd:
	jumpifbyte ANDS USER_BANK 0x1 FoeSeaOfFire

YourSeaOfFire:
	setword BATTLE_STRING_LOADER PlayerSeaOfFireEndString
	goto PrintTimerString

FoeSeaOfFire:
	setword BATTLE_STRING_LOADER FoeSeaOfFireEndString
	goto PrintTimerString

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_SwampEnd:
	jumpifbyte ANDS USER_BANK 0x1 FoeSwamp

YourSwamp:
	setword BATTLE_STRING_LOADER PlayerSwampEndString
	goto PrintTimerString

FoeSwamp:
	setword BATTLE_STRING_LOADER FoeSwampEndString
	goto PrintTimerString

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_TrickRoomEnd:
	setword BATTLE_STRING_LOADER TrickRoomEndString
	goto PrintTimerString


BattleScript_WaterSportEnd:
	setword BATTLE_STRING_LOADER WaterSportEndString
	goto PrintTimerString


BattleScript_MudSportEnd:
	setword BATTLE_STRING_LOADER MudSportEndString
	goto PrintTimerString


BattleScript_WonderRoomEnd:
	setword BATTLE_STRING_LOADER WonderRoomEndString
	goto PrintTimerString


BattleScript_MagicRoomEnd:
	setword BATTLE_STRING_LOADER MagicRoomEndString
	goto PrintTimerString


BattleScript_GravityEnd:
	setword BATTLE_STRING_LOADER GravityEndString
	goto PrintTimerString


BattleScript_TerrainEnd:
	setbyte TERRAIN_BYTE 0x0
	setword BATTLE_STRING_LOADER TerrainEndString

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

PrintTimerString:
	printstring 0x184
	waitmessage DELAY_1SECOND
	end2
	
@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_ToxicOrb:
	setbyte POISONED_BY 0x3
	orword HIT_MARKER 0x2100 @Ignore Safeguard and Substitute
	setbyte EFFECT_BYTE 0x6
	seteffecttarget
	end2

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_FlameOrb:
	setbyte POISONED_BY 0x3
	orword HIT_MARKER 0x2100 @Ignore Safeguard and Substitute
	setbyte EFFECT_BYTE 0x3
	seteffecttarget
	end2

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_ZenMode:
	setword BATTLE_STRING_LOADER AbilityActivatedString
	printstring 0x184
	waitmessage DELAY_HALFSECOND
	playanimation BANK_ATTACKER ANIM_TRANSFORM 0x0
	end2

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_PowerConstruct:
	setword BATTLE_STRING_LOADER PresenceOfManyString
	printstring 0x184
	waitmessage DELAY_HALFSECOND
	playanimation BANK_ATTACKER ANIM_ZYGARDE_CELL_SWIRL 0x0
	reloadhealthbar BANK_ATTACKER
	setword BATTLE_STRING_LOADER PowerConstructCompleteString
	printstring 0x184
	waitmessage DELAY_1SECOND
	end2

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_StartedSchooling:
	call BattleScript_StartedSchoolingRet
	end2

.global BattleScript_StartedSchoolingRet
BattleScript_StartedSchoolingRet:
	playanimation BANK_ATTACKER ANIM_WISHIWASHI_FISH 0x0
	setword BATTLE_STRING_LOADER StartedSchoolingString
	printstring 0x184
	waitmessage DELAY_1SECOND
	return

BattleScript_StoppedSchooling:
	call BattleScript_StoppedSchoolingRet
	end2

.global BattleScript_StoppedSchoolingRet
BattleScript_StoppedSchoolingRet:
	playanimation BANK_ATTACKER ANIM_WISHIWASHI_FISH 0x0
	setword BATTLE_STRING_LOADER StoppedSchoolingString
	printstring 0x184
	waitmessage DELAY_1SECOND
	return

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_ShieldsDownToCore:
	call BattleScript_ShieldsDownToCoreRet
	end2

.global BattleScript_ShieldsDownToCoreRet
BattleScript_ShieldsDownToCoreRet:
	playanimation BANK_ATTACKER ANIM_TRANSFORM 0x0
	setword BATTLE_STRING_LOADER ToCoreString
	printstring 0x184
	waitmessage DELAY_1SECOND
	return

BattleScript_ShieldsDownToMeteor:
	call BattleScript_ShieldsDownToMeteorRet
	end2

.global BattleScript_ShieldsDownToMeteorRet
BattleScript_ShieldsDownToMeteorRet:
	playanimation BANK_ATTACKER ANIM_TRANSFORM 0x0
	setword BATTLE_STRING_LOADER ToMeteorString
	printstring 0x184
	waitmessage DELAY_1SECOND
	return

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_FlowerGift:
	playanimation BANK_ATTACKER ANIM_TRANSFORM 0x0
	setword BATTLE_STRING_LOADER TransformedString
	printstring 0x184
	waitmessage DELAY_1SECOND
	end2

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_MonTookFutureAttack:
	printstring 0xA2 @;STRINGID_PKMNTOOKATTACK
	waitmessage DELAY_1SECOND
	jumpifmove MOVE_DOOMDESIRE BattleScript_CheckDoomDesireMiss
	accuracycheck BattleScript_FutureAttackMiss MOVE_FUTURESIGHT
	goto BattleScript_CalcDamage

BattleScript_CheckDoomDesireMiss:
	accuracycheck BattleScript_FutureAttackMiss MOVE_DOOMDESIRE

BattleScript_CalcDamage:
	critcalc
	callasm FutureSightDamageCalc + 1
	typecalc
	adjustnormaldamage2
	jumpifmove MOVE_DOOMDESIRE BattleScript_FutureHitAnimDoomDesire
	playanimation BANK_ATTACKER ANIM_FUTURE_SIGHT_HIT 0x0
	goto BattleScript_DoFutureAttackHit

BattleScript_FutureHitAnimDoomDesire:
	playanimation BANK_ATTACKER ANIM_DOOM_DESIRE_HIT 0x0

BattleScript_DoFutureAttackHit:
	effectivenesssound
	flash BANK_TARGET
	waitstateatk
	graphicalhpupdate BANK_TARGET
	datahpupdate BANK_TARGET
	resultmessage
	waitmessage DELAY_1SECOND
	faintpokemon BANK_TARGET 0x0 0x0
	ifwildbattleend BattleScript_FutureAttackEnd

BattleScript_FutureAttackEnd:
	setbyte CMD49_STATE 0x0
	cmd49 0x3 0x0
	setbyte OUTCOME 0
	end2
	
BattleScript_FutureAttackMiss:
	pause DELAY_HALFSECOND
	setbyte OUTCOME 0
	orbyte OUTCOME OUTCOME_FAILED
	resultmessage
	waitmessage DELAY_1SECOND
	setbyte OUTCOME 0
	end2

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_Victory:
	jumpifword ANDS BATTLE_TYPE BATTLE_TWO_OPPONENTS BeatTwoPeeps
	printstring 0x141
	goto PostBeatString
	
BeatTwoPeeps:
	setword BATTLE_STRING_LOADER BattleText_TwoInGameTrainersDefeated
	printstring 0x184
	
PostBeatString:
	trainerslidein 0x1
	waitstateatk
	jumpifword ANDS BATTLE_TYPE BATTLE_E_READER 0x81D88FF @Just Pickup Calc
	printstring 0xC
	jumpifword NOTANDS BATTLE_TYPE BATTLE_TWO_OPPONENTS CheckJumpLocForEndBattle
	callasm TrainerSlideOut+1
	waitstateatk
	trainerslidein 0x3
	waitstateatk
	setword BATTLE_STRING_LOADER TrainerBLoseString
	printstring 0x184

CheckJumpLocForEndBattle:
	jumpifword ANDS BATTLE_TYPE BATTLE_TOWER 0x81D8900 @No Money Give
	jumpifword NOTANDS BATTLE_TYPE BATTLE_TRAINER_TOWER 0x81D87F8 @Give Money
	jumpifword NOTANDS BATTLE_TYPE BATTLE_DOUBLE 0x81D88FF @Just Pickup Calc
	printstring 0x177 @Buffer Trainer Tower Win Text
	goto 0x81D88FF @Just Pickup Calc
	
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_PrintPlayerForfeited:	
	printstring 374 @STRINGID_FORFEITED_MATCH
	waitmessage 0x40
	end2
	
BattleScript_PrintPlayerForfeitedLinkBattle:
	printstring 374 @STRINGID_FORFEITED_MATCH
	waitmessage DELAY_1SECOND
	flee
	waitmessage DELAY_1SECOND
	end2

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_LostMultiBattleTower:
	returnopponentmon1toball BANK_ATTACKER
	waitstateatk
	returnopponentmon2toball BANK_ATTACKER
	waitstateatk
	trainerslidein BANK_ATTACKER
	waitstateatk
	printstring 0x174 @STRINGID_TRAINER1WINTEXT
	callasm TrainerSlideOut+1
	waitstateatk
	trainerslidein 0x3
	waitstateatk
	setword BATTLE_STRING_LOADER TrainerBVictoryString
	printstring 0x184
	flee
	waitmessage DELAY_1SECOND
	end2
	
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_LostBattleTower:
	returnopponentmon1toball BANK_ATTACKER
	waitstateatk
	trainerslidein BANK_ATTACKER
	waitstateatk
	printstring 0x174 @STRINGID_TRAINER1WINTEXT
	flee
	waitmessage DELAY_1SECOND
	end2

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_PrintCustomStringEnd3:
	call BattleScript_PrintCustomString
	end3

.align 2
MysteriousAirCurrentContinuesString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xE1, 0xED, 0xE7, 0xE8, 0xD9, 0xE6, 0xDD, 0xE3, 0xE9, 0xE7, 0x00, 0xD5, 0xDD, 0xE6, 0x00, 0xD7, 0xE9, 0xE6, 0xE6, 0xD9, 0xE2, 0xE8, 0xFE, 0xD7, 0xE3, 0xE2, 0xE8, 0xDD, 0xE2, 0xE9, 0xD9, 0xE7, 0x00, 0xE8, 0xE3, 0x00, 0xD6, 0xE0, 0xE3, 0xEB, 0xAD, 0xFF
FogEndedString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xDA, 0xE3, 0xDB, 0x00, 0xD8, 0xDD, 0xE7, 0xD5, 0xE4, 0xE4, 0xD9, 0xD5, 0xE6, 0xD9, 0xD8, 0xAD, 0xFF
FogContinuesString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xDA, 0xE3, 0xDB, 0x00, 0xDD, 0xE7, 0x00, 0xD8, 0xD9, 0xD9, 0xE4, 0xAD, 0xAD, 0xAD, 0xFF
SeaOfFireDamageString: .byte 0xFD, 0x0F, 0x00, 0xDD, 0xE7, 0x00, 0xDC, 0xE9, 0xE6, 0xE8, 0x00, 0xD6, 0xED, 0xFE, 0xE8, 0xDC, 0xD9, 0x00, 0xE7, 0xD9, 0xD5, 0x00, 0xE3, 0xDA, 0x00, 0xDA, 0xDD, 0xE6, 0xD9, 0xAB, 0xFF
GrassyTerrainHealString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xDB, 0xE6, 0xD5, 0xE7, 0xE7, 0xED, 0x00, 0xE8, 0xD9, 0xE6, 0xE6, 0xD5, 0xDD, 0xE2, 0x00, 0xE6, 0xD9, 0xE7, 0xE8, 0xE3, 0xE6, 0xD9, 0xD8, 0xFE, 0xFD, 0x0F, 0xB4, 0xE7, 0x00, 0xDC, 0xD9, 0xD5, 0xE0, 0xE8, 0xDC, 0xAB, 0xFF
AquaRingHealString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xBB, 0xE5, 0xE9, 0xD5, 0x00, 0xCC, 0xDD, 0xE2, 0xDB, 0x00, 0xE6, 0xD9, 0xE7, 0xE8, 0xE3, 0xE6, 0xD9, 0xD8, 0xFE, 0xFD, 0x0F, 0xB4, 0xE7, 0x00, 0xDC, 0xD9, 0xD5, 0xE0, 0xE8, 0xDC, 0xAB, 0xFF
PoisonHealString: .byte 0xFD, 0x0F, 0xB4, 0xE7, 0x00, 0xFD, 0x18, 0xFE, 0xE6, 0xD9, 0xE7, 0xE8, 0xE3, 0xE6, 0xD9, 0xD8, 0x00, 0xDD, 0xE8, 0xE7, 0x00, 0xC2, 0xCA, 0xAB, 0xFF
MagnetRiseEndString: .byte 0xFD, 0x0F, 0xB4, 0xE7, 0xFE, 0xD9, 0xE0, 0xD9, 0xD7, 0xE8, 0xE6, 0xE3, 0xE1, 0xD5, 0xDB, 0xE2, 0xD9, 0xE8, 0xDD, 0xE7, 0xE1, 0x00, 0xEB, 0xE3, 0xE6, 0xD9, 0x00, 0xE3, 0xDA, 0xDA, 0xAB, 0xFF
TelekinesisStringEndString: .byte 0xFD, 0x0F, 0x00, 0xEB, 0xD5, 0xE7, 0x00, 0xDA, 0xE6, 0xD9, 0xD9, 0xD8, 0xFE, 0xDA, 0xE6, 0xE3, 0xE1, 0x00, 0xE8, 0xDC, 0xD9, 0x00, 0xE8, 0xD9, 0xE0, 0xD9, 0xDF, 0xDD, 0xE2, 0xD9, 0xE7, 0xDD, 0xE7, 0xAB, 0xFF
HealBlockEndString: .byte 0xFD, 0x0F, 0xB4, 0xE7, 0xFE, 0xC2, 0xD9, 0xD5, 0xE0, 0x00, 0xBC, 0xE0, 0xE3, 0xD7, 0xDF, 0x00, 0xEB, 0xE3, 0xE6, 0xD9, 0x00, 0xE3, 0xDA, 0xDA, 0xAB, 0xFF
EmbargoEndString: .byte 0xFD, 0x0F, 0xB4, 0xE7, 0xFE, 0xBF, 0xE1, 0xD6, 0xD5, 0xE6, 0xDB, 0xE3, 0x00, 0xD9, 0xE2, 0xD8, 0xD9, 0xD8, 0xAB, 0xFF
PlayerAuroraVeilEndString: .byte 0xD3, 0xE3, 0xE9, 0xE6, 0x00, 0xE8, 0xD9, 0xD5, 0xE1, 0xB4, 0xE7, 0x00, 0xBB, 0xE9, 0xE6, 0xE3, 0xE6, 0xD5, 0x00, 0xD0, 0xD9, 0xDD, 0xE0, 0xFE, 0xEB, 0xE3, 0xE6, 0xD9, 0x00, 0xE3, 0xDA, 0xDA, 0xAB, 0xFF
FoeAuroraVeilEndString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xE3, 0xE4, 0xE4, 0xE3, 0xE7, 0xDD, 0xE2, 0xDB, 0x00, 0xE8, 0xD9, 0xD5, 0xE1, 0xB4, 0xE7, 0x00, 0xBB, 0xE9, 0xE6, 0xE3, 0xE6, 0xD5, 0x00, 0xD0, 0xD9, 0xDD, 0xE0, 0xFE, 0xEB, 0xE3, 0xE6, 0xD9, 0x00, 0xE3, 0xDA, 0xDA, 0xAB, 0xFF
PlayerTailwindEndString: .byte 0xD3, 0xE3, 0xE9, 0xE6, 0x00, 0xE8, 0xD9, 0xD5, 0xE1, 0xB4, 0xE7, 0x00, 0xE8, 0xD5, 0xDD, 0xE0, 0xEB, 0xDD, 0xE2, 0xD8, 0x00, 0xE4, 0xD9, 0xE8, 0xD9, 0xE6, 0xD9, 0xD8, 0x00, 0xE3, 0xE9, 0xE8, 0xAB, 0xFF
FoeTailwindEndString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xE3, 0xE4, 0xE4, 0xE3, 0xE7, 0xDD, 0xE2, 0xDB, 0x00, 0xE8, 0xD9, 0xD5, 0xE1, 0xB4, 0xE7, 0x00, 0xE8, 0xD5, 0xDD, 0xE0, 0xEB, 0xDD, 0xE2, 0xD8, 0xFE, 0xE4, 0xD9, 0xE8, 0xD9, 0xE6, 0xD9, 0xD8, 0x00, 0xE3, 0xE9, 0xE8, 0xAB, 0xFF
PlayerLuckyChantEndString: .byte 0xD3, 0xE3, 0xE9, 0xE6, 0x00, 0xE8, 0xD9, 0xD5, 0xE1, 0xB4, 0xE7, 0x00, 0xC6, 0xE9, 0xD7, 0xDF, 0xED, 0x00, 0xBD, 0xDC, 0xD5, 0xE2, 0xE8, 0x00, 0xEB, 0xE3, 0xE6, 0xD9, 0x00, 0xE3, 0xDA, 0xDA, 0xAB, 0xFF
FoeLuckyChantEndString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xE3, 0xE4, 0xE4, 0xE3, 0xE7, 0xDD, 0xE2, 0xDB, 0x00, 0xE8, 0xD9, 0xD5, 0xE1, 0xB4, 0xE7, 0x00, 0xC6, 0xE9, 0xD7, 0xDF, 0xED, 0x00, 0xBD, 0xDC, 0xD5, 0xE2, 0xE8, 0xFE, 0xEB, 0xE3, 0xE6, 0xD9, 0x00, 0xE3, 0xDA, 0xDA, 0xAB, 0xFF
PlayerRainbowEndString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xE6, 0xD5, 0xDD, 0xE2, 0xD6, 0xE3, 0xEB, 0x00, 0xE3, 0xE2, 0x00, 0xED, 0xE3, 0xE9, 0xE6, 0x00, 0xE8, 0xD9, 0xD5, 0xE1, 0xB4, 0xE7, 0x00, 0xE7, 0xDD, 0xD8, 0xD9, 0xFE, 0xD8, 0xDD, 0xE7, 0xD5, 0xE4, 0xE4, 0xD9, 0xD5, 0xE6, 0xD9, 0xD8, 0xAB, 0xFF
FoeRainbowEndString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xE6, 0xD5, 0xDD, 0xE2, 0xD6, 0xE3, 0xEB, 0x00, 0xE3, 0xE2, 0x00, 0xE8, 0xDC, 0xD9, 0x00, 0xE3, 0xE4, 0xE4, 0xE3, 0xE7, 0xDD, 0xE2, 0xDB, 0x00, 0xE8, 0xD9, 0xD5, 0xE1, 0xB4, 0xE7, 0xFE, 0xE7, 0xDD, 0xD8, 0xD9, 0x00, 0xD8, 0xDD, 0xE7, 0xD5, 0xE4, 0xE4, 0xD9, 0xD5, 0xE6, 0xD9, 0xD8, 0xAB, 0xFF
PlayerSeaOfFireEndString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xE7, 0xD9, 0xD5, 0x00, 0xE3, 0xDA, 0x00, 0xDA, 0xDD, 0xE6, 0xD9, 0x00, 0xD8, 0xDD, 0xE7, 0xD5, 0xE4, 0xE4, 0xD9, 0xD5, 0xE6, 0xD9, 0xD8, 0x00, 0xDA, 0xE6, 0xE3, 0xE1, 0xFE, 0xD5, 0xE6, 0xE3, 0xE9, 0xE2, 0xD8, 0x00, 0xED, 0xE3, 0xE9, 0xE6, 0x00, 0xE8, 0xD9, 0xD5, 0xE1, 0xAB, 0xFF
FoeSeaOfFireEndString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xE7, 0xD9, 0xD5, 0x00, 0xE3, 0xDA, 0x00, 0xDA, 0xDD, 0xE6, 0xD9, 0x00, 0xD8, 0xDD, 0xE7, 0xD5, 0xE4, 0xE4, 0xD9, 0xD5, 0xE6, 0xD9, 0xD8, 0x00, 0xDA, 0xE6, 0xE3, 0xE1, 0xFE, 0xD5, 0xE6, 0xE3, 0xE9, 0xE2, 0xD8, 0x00, 0xE8, 0xDC, 0xD9, 0x00, 0xE3, 0xE4, 0xE4, 0xE3, 0xE7, 0xDD, 0xE2, 0xDB, 0x00, 0xE8, 0xD9, 0xD5, 0xE1, 0xAB, 0xFF
PlayerSwampEndString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xE7, 0xEB, 0xD5, 0xE1, 0xE4, 0x00, 0xD5, 0xE6, 0xE3, 0xE9, 0xE2, 0xD8, 0x00, 0xED, 0xE3, 0xE9, 0xE6, 0x00, 0xE8, 0xD9, 0xD5, 0xE1, 0xFE, 0xD8, 0xDD, 0xE7, 0xD5, 0xE4, 0xE4, 0xD9, 0xD5, 0xE6, 0xD9, 0xD8, 0xAB, 0xFF
FoeSwampEndString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xE7, 0xEB, 0xD5, 0xE1, 0xE4, 0x00, 0xD5, 0xE6, 0xE3, 0xE9, 0xE2, 0xD8, 0x00, 0xE8, 0xDC, 0xD9, 0x00, 0xE3, 0xE4, 0xE4, 0xE3, 0xE7, 0xDD, 0xE2, 0xDB, 0xFE, 0xE8, 0xD9, 0xD5, 0xE1, 0x00, 0xD8, 0xDD, 0xE7, 0xD5, 0xE4, 0xE4, 0xD9, 0xD5, 0xE6, 0xD9, 0xD8, 0xAB, 0xFF
TrickRoomEndString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xE8, 0xEB, 0xDD, 0xE7, 0xE8, 0xD9, 0xD8, 0x00, 0xD8, 0xDD, 0xE1, 0xD9, 0xE2, 0xE7, 0xDD, 0xE3, 0xE2, 0xE7, 0x00, 0xE6, 0xD9, 0xE8, 0xE9, 0xE6, 0xE2, 0xD9, 0xD8, 0xFE, 0xE8, 0xE3, 0x00, 0xE2, 0xE3, 0xE6, 0xE1, 0xD5, 0xE0, 0xAB, 0xFF
WaterSportEndString: .byte 0xD1, 0xD5, 0xE8, 0xD9, 0xE6, 0x00, 0xCD, 0xE4, 0xE3, 0xE6, 0xE8, 0xB4, 0xE7, 0x00, 0xD9, 0xDA, 0xDA, 0xD9, 0xD7, 0xE8, 0xE7, 0x00, 0xEB, 0xE3, 0xE6, 0xD9, 0x00, 0xE3, 0xDA, 0xDA, 0xAB, 0xFF
MudSportEndString: .byte 0xC7, 0xE9, 0xD8, 0x00, 0xCD, 0xE4, 0xE3, 0xE6, 0xE8, 0xB4, 0xE7, 0x00, 0xD9, 0xDA, 0xDA, 0xD9, 0xD7, 0xE8, 0xE7, 0x00, 0xEB, 0xE3, 0xE6, 0xD9, 0x00, 0xE3, 0xDA, 0xDA, 0xAB, 0xFF
WonderRoomEndString: .byte 0xD1, 0xE3, 0xE2, 0xD8, 0xD9, 0xE6, 0x00, 0xCC, 0xE3, 0xE3, 0xE1, 0x00, 0xEB, 0xE3, 0xE6, 0xD9, 0x00, 0xE3, 0xDA, 0xDA, 0xB8, 0x00, 0xD5, 0xE2, 0xD8, 0x00, 0xE8, 0xDC, 0xD9, 0x00, 0xBE, 0xD9, 0xDA, 0xD9, 0xE2, 0xE7, 0xD9, 0xFE, 0xD5, 0xE2, 0xD8, 0x00, 0xCD, 0xE4, 0xAD, 0x00, 0xBE, 0xD9, 0xDA, 0xAD, 0x00, 0xE7, 0xE8, 0xD5, 0xE8, 0xE7, 0x00, 0xE6, 0xD9, 0xE8, 0xE9, 0xE6, 0xE2, 0xD9, 0xD8, 0x00, 0xE8, 0xE3, 0x00, 0xE2, 0xE3, 0xE6, 0xE1, 0xD5, 0xE0, 0xAB, 0xFF
MagicRoomEndString: .byte 0xC7, 0xD5, 0xDB, 0xDD, 0xD7, 0x00, 0xCC, 0xE3, 0xE3, 0xE1, 0x00, 0xEB, 0xE3, 0xE6, 0xD9, 0x00, 0xE3, 0xDA, 0xDA, 0xB8, 0x00, 0xD5, 0xE2, 0xD8, 0x00, 0xDC, 0xD9, 0xE0, 0xD8, 0x00, 0xDD, 0xE8, 0xD9, 0xE1, 0xE7, 0xB4, 0xFE, 0xD9, 0xDA, 0xDA, 0xD9, 0xD7, 0xE8, 0xE7, 0x00, 0xE6, 0xD9, 0xE8, 0xE9, 0xE6, 0xE2, 0xD9, 0xD8, 0x00, 0xE8, 0xE3, 0x00, 0xE2, 0xE3, 0xE6, 0xE1, 0xD5, 0xE0, 0xAB, 0xFF
GravityEndString: .byte 0xC1, 0xE6, 0xD5, 0xEA, 0xDD, 0xE8, 0xED, 0x00, 0xE6, 0xD9, 0xE8, 0xE9, 0xE6, 0xE2, 0xD9, 0xD8, 0x00, 0xE8, 0xE3, 0x00, 0xE2, 0xE3, 0xE6, 0xE1, 0xD5, 0xE0, 0xAB, 0xFF
TerrainEndString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xE8, 0xD9, 0xE6, 0xE6, 0xD5, 0xDD, 0xE2, 0x00, 0xE6, 0xD9, 0xE8, 0xE9, 0xE6, 0xE2, 0xD9, 0xD8, 0x00, 0xE8, 0xE3, 0x00, 0xE2, 0xE3, 0xE6, 0xE1, 0xD5, 0xE0, 0xAB, 0xFF
AbilityActivatedString: .byte 0xFD, 0x13, 0xB4, 0xE7, 0x00, 0xFD, 0x1A, 0xFE, 0xD5, 0xD7, 0xE8, 0xDD, 0xEA, 0xD5, 0xE8, 0xD9, 0xD8, 0xAB, 0xFF
PresenceOfManyString: .byte 0xD3, 0xE3, 0xE9, 0x00, 0xE7, 0xD9, 0xE2, 0xE7, 0xD9, 0x00, 0xE8, 0xDC, 0xD9, 0x00, 0xE4, 0xE6, 0xD9, 0xE7, 0xD9, 0xE2, 0xD7, 0xD9, 0x00, 0xE3, 0xDA, 0x00, 0xE1, 0xD5, 0xE2, 0xED, 0xAD, 0xFA, 0xFD, 0x0F, 0xB4, 0xE7, 0x00, 0xFD, 0x18, 0xFE, 0xD5, 0xD7, 0xE8, 0xDD, 0xEA, 0xD5, 0xE8, 0xD9, 0xD8, 0xAB, 0xFF
PowerConstructCompleteString: .byte 0xFD, 0x0F, 0x00, 0xE8, 0xE6, 0xD5, 0xE2, 0xE7, 0xDA, 0xE3, 0xE6, 0xE1, 0xD9, 0xD8, 0xFE, 0xDD, 0xE2, 0xE8, 0xE3, 0x00, 0xDD, 0xE8, 0xE7, 0x00, 0xBD, 0xE3, 0xE1, 0xE4, 0xE0, 0xD9, 0xE8, 0xD9, 0x00, 0xC0, 0xE3, 0xE6, 0xE1, 0xAB, 0xFF
StartedSchoolingString: .byte 0xFD, 0x0F, 0x00, 0xDA, 0xE3, 0xE6, 0xE1, 0xD9, 0xD8, 0x00, 0xD5, 0x00, 0xE7, 0xD7, 0xDC, 0xE3, 0xE3, 0xE0, 0xAB, 0xFF
StoppedSchoolingString: .byte 0xFD, 0x0F, 0x00, 0xE7, 0xE8, 0xE3, 0xE4, 0xE4, 0xD9, 0xD8, 0xFE, 0xE7, 0xD7, 0xDC, 0xE3, 0xE3, 0xE0, 0xDD, 0xE2, 0xDB, 0xAB, 0xFF
ToCoreString: .byte 0xFD, 0x0F, 0xB4, 0xE7, 0x00, 0xFD, 0x18, 0xFE, 0xD5, 0xD7, 0xE8, 0xDD, 0xEA, 0xD5, 0xE8, 0xD9, 0xD8, 0xAB, 0xFF
ToMeteorString: .byte 0xFD, 0x0F, 0xB4, 0xE7, 0x00, 0xFD, 0x18, 0xFE, 0xD8, 0xD9, 0xD5, 0xD7, 0xE8, 0xDD, 0xEA, 0xD5, 0xE8, 0xD9, 0xD8, 0xAB, 0xFF
TransformedString: .byte 0xFD, 0x13, 0x00, 0xE8, 0xE6, 0xD5, 0xE2, 0xE7, 0xDA, 0xE3, 0xE6, 0xE1, 0xD9, 0xD8, 0xAB, 0xFF
TrainerBLoseString: .byte 0xFD, 0x30, 0xFF
TrainerBVictoryString: .byte 0xFD, 0x31, 0xFF

.align 2
SeaOfFireDamageASM:
	push {lr}
	ldr r0, =USER_BANK
	ldrb r0, [r0]
	bl GetCurrentHealth
	ldrh r0, [r1, #0x4]
	lsr r0, #0x2
	cmp r0, #0x0
	bne SetSOFDamage
	mov r0, #0x1

SetSOFDamage:
	ldr r1, =DAMAGE_LOC
	str r0, [r1]
	pop {pc}
	

GrassyTerrainHeal:
	push {lr}
	ldr r0, =USER_BANK
	ldrb r0, [r0]
	bl GetCurrentHealth
	ldrh r0, [r1, #0x4]
	lsr r0, #0x3
	cmp r0, #0x0
	bne SetGTHeal
	mov r0, #0x1

SetGTHeal:
	ldr r1, =DAMAGE_LOC
	neg r0, r0
	str r0, [r1]
	pop {pc}
