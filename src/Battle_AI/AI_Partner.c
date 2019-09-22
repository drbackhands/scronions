#include "../defines.h"
#include "../defines_battle.h"
#include "../../include/random.h"
#include "../../include/constants/items.h"

#include "../../include/new/ability_tables.h"
#include "../../include/new/accuracy_calc.h"
#include "../../include/new/AI_advanced.h"
#include "../../include/new/AI_Helper_Functions.h"
#include "../../include/new/battle_start_turn_start.h"
#include "../../include/new/battle_util.h"
#include "../../include/new/damage_calc.h"
#include "../../include/new/general_bs_commands.h"
#include "../../include/new/Helper_Functions.h"
#include "../../include/new/item.h"
#include "../../include/new/move_tables.h"

#define PARTNER_MOVE_EFFECT_IS_SKILL_SWAP (gChosenMovesByBanks[bankAtkPartner] != MOVE_NONE \
										&& gBattleStruct->moveTarget[bankAtkPartner] == bankAtk \
										&& gBattleMoves[partnerMove].effect == EFFECT_SKILL_SWAP)

extern move_effect_t StatLowerTable[];
extern const struct NaturalGiftStruct gNaturalGiftTable[];
extern const struct FlingStruct gFlingTable[];

u8 AI_Script_Partner(const u8 bankAtk, const u8 bankAtkPartner, const u16 originalMove, const u8 originalViability)
{
	//u32 i, j;
	u8 class = PredictBankFightingStyle(bankAtk);
	s16 viability = originalViability;

	//Load Alternative targets
	u8 bankDef = bankAtkPartner;
	u8 foe1, foe2;
	foe1 = FOE(bankAtk);
	foe2 = PARTNER(FOE(bankAtk));

	//Get relevant params
	u16 move = TryReplaceMoveWithZMove(bankAtk, bankAtkPartner, originalMove);	
	u8 moveEffect = gBattleMoves[move].effect;
	u8 moveType = GetMoveTypeSpecial(bankAtk, move);
	
	u16 partnerMove = (gChosenMovesByBanks[bankAtkPartner] != MOVE_NONE) ? gChosenMovesByBanks[bankAtkPartner] : IsValidMovePrediction(bankAtkPartner, FOE(bankAtk));
	
	//u8 atkItemEffect = ITEM_EFFECT(bankAtk);
	u8 atkPartnerItemEffect = ITEM_EFFECT(bankAtkPartner);
	
	u8 atkAbility = GetAIAbility(bankAtk, foe1, move);
	u8 atkPartnerAbility = ABILITY(bankAtkPartner);

	if (!NO_MOLD_BREAKERS(atkAbility, move)
	&& gMoldBreakerIgnoredAbilities[atkPartnerAbility])
		atkPartnerAbility = ABILITY_NONE;

	u8 moveSplit = CalcMoveSplit(bankAtk, move);
	bool8 partnerProtects = DoesProtectionMoveBlockMove(bankAtk, bankAtkPartner, move, partnerMove);
	bool8 onlyHitsBothFoes = gBattleMoves[move].target == MOVE_TARGET_BOTH;

	if (!partnerProtects && !onlyHitsBothFoes)
	{
		switch (atkPartnerAbility) //Type-specific ability checks - primordial weather handled separately
		{
			//Electric
			case ABILITY_VOLTABSORB:
				if (moveType == TYPE_ELECTRIC)
					IncreaseHealPartnerViability(&viability, class, bankAtkPartner);
				break;
			case ABILITY_MOTORDRIVE:
				if (moveType == TYPE_ELECTRIC
				&&  SpecialMoveInMoveset(bankAtkPartner)
				&&  STAT_CAN_RISE(bankAtkPartner, STAT_STAGE_SPEED))
				{
					IncreaseHelpingHandViability(&viability, class);
				}
				break;
			case ABILITY_LIGHTNINGROD:
				if (moveType == TYPE_ELECTRIC
				&&  SpecialMoveInMoveset(bankAtkPartner)
				&&  STAT_CAN_RISE(bankAtkPartner, STAT_STAGE_SPATK))
				{
					IncreaseHelpingHandViability(&viability, class);
				}
				break;

			// Water
			case ABILITY_WATERABSORB:
			case ABILITY_DRYSKIN:
				if (moveType == TYPE_WATER)
					IncreaseHealPartnerViability(&viability, class, bankAtkPartner);
				break;
			case ABILITY_STORMDRAIN:
				if (moveType == TYPE_WATER
				&&  SpecialMoveInMoveset(bankAtkPartner)
				&&  STAT_CAN_RISE(bankAtkPartner, STAT_STAGE_SPATK))
				{
					IncreaseHelpingHandViability(&viability, class);
				}
				break;
			
			//case ABILITY_WATERCOMPACTION:
			//	if (moveType == TYPE_WATER)
			//		return viability - 10;
			//	break;

			// Fire	
			case ABILITY_FLASHFIRE:
				if (moveType == TYPE_FIRE
				&&  MoveTypeInMoveset(bankAtkPartner, TYPE_FIRE)
				&&  !(gBattleResources->flags->flags[bankAtkPartner] & RESOURCE_FLAG_FLASH_FIRE))
				{
					IncreaseHelpingHandViability(&viability, class);
				}
				break;

			// Grass
			case ABILITY_SAPSIPPER:
				if (moveType == TYPE_GRASS
				&&  PhysicalMoveInMoveset(bankAtkPartner)
				&&  STAT_CAN_RISE(bankAtkPartner, STAT_STAGE_ATK))
				{
					IncreaseHelpingHandViability(&viability, class);
				}
				break;

			// Dark
			case ABILITY_JUSTIFIED:
				if (moveType == TYPE_DARK
				&&  moveSplit != SPLIT_STATUS
				&&  PhysicalMoveInMoveset(bankAtkPartner)
				&&  STAT_CAN_RISE(bankAtkPartner, STAT_STAGE_ATK)
				&&  !MoveKnocksOutXHits(move, bankAtk, bankAtkPartner, 1))
				{
					IncreaseHelpingHandViability(&viability, class);
				}
				break;

			//Multiple move types
			case ABILITY_RATTLED:
				if (moveSplit != SPLIT_STATUS
				&& (moveType == TYPE_DARK || moveType == TYPE_GHOST || moveType == TYPE_BUG)
				&&  STAT_CAN_RISE(bankAtkPartner, STAT_STAGE_SPEED)
				&&  !MoveKnocksOutXHits(move, bankAtk, bankAtkPartner, 1))
				{
					IncreaseHelpingHandViability(&viability, class);
				}
				break;
			
			//Move category checks
			case ABILITY_CONTRARY:
				if (CheckTableForMoveEffect(move, StatLowerTable))
				{
					IncreaseHelpingHandViability(&viability, class);
				}
				break;
		
			case ABILITY_DEFIANT:
				if (CheckTableForMoveEffect(move, StatLowerTable)
				&&  STAT_CAN_RISE(bankAtkPartner, STAT_STAGE_ATK))
				{
					IncreaseHelpingHandViability(&viability, class);
				}
				break;
			case ABILITY_COMPETITIVE:
				if (CheckTableForMoveEffect(move, StatLowerTable)
				&&  STAT_CAN_RISE(bankAtkPartner, STAT_STAGE_SPATK))
				{
					IncreaseHelpingHandViability(&viability, class);
				}
				break;
				
			//Mummy
			case ABILITY_MUMMY: ;
				u8 atkSpd = SpeedCalc(bankAtk);
				if (SpeedCalc(foe1) < atkSpd) //Attacker is faster than foe 1
				{
					if (CanKnockOut(foe1, bankAtk)) //Foe 1 will KO before benefit can be used
						break;
				}
				else //Attacker is slower than foe 1
				{
					if (Can2HKO(foe1, bankAtk)) //Foe 1 will KO before benefit can be used
						break;
				}
				
				if (SpeedCalc(foe2) < atkSpd) //Attacker is faster than foe 2
				{
					if (CanKnockOut(foe2, bankAtk)) //Foe 2 will KO before benefit can be used
						break;
				}
				else //Attacker is slower than foe 2
				{
					if (Can2HKO(foe2, bankAtk)) //Foe 2 will KO before benefit can be used
						break;
				}

				if (atkAbility == ABILITY_TRUANT //Try to get rid of these abilities
				||  atkAbility == ABILITY_SLOWSTART
				||  atkAbility == ABILITY_DEFEATIST)
				{
					if (CheckContact(move, bankAtk) //Mummy will transfer
					&& !PARTNER_MOVE_EFFECT_IS_SKILL_SWAP
					&& !(TypeCalc(move, bankAtk, bankAtkPartner, NULL, FALSE) & MOVE_RESULT_NO_EFFECT) //Move has effect
					&& IsWeakestContactMoveWithBestAccuracy(move, bankAtk, bankAtkPartner)) //Hit partner with weakest move
						IncreaseDoublesDamageViabilityToScore(&viability, class, BEST_DOUBLES_KO_SCORE, bankAtk, bankAtkPartner); //Best move to use
				}
		}
	}
	
	switch (moveEffect) {
		case EFFECT_EVASION_UP:
			if (move == MOVE_ACUPRESSURE && !partnerProtects)
				IncreaseHelpingHandViability(&viability, class);
			break;
			
		case EFFECT_SWAGGER:
			if (STAT_STAGE(bankAtkPartner, STAT_STAGE_ATK) < STAT_STAGE_MAX
			&& (!CanBeConfused(bankAtkPartner)
			 || atkPartnerItemEffect == ITEM_EFFECT_CURE_CONFUSION
			 || atkPartnerItemEffect == ITEM_EFFECT_CURE_STATUS))
				IncreaseHelpingHandViability(&viability, class);
			break;
		
		case EFFECT_FLATTER:
			if (STAT_STAGE(bankAtkPartner, STAT_STAGE_SPATK) < STAT_STAGE_MAX
			&& (!CanBeConfused(bankAtkPartner)
			 || atkPartnerItemEffect == ITEM_EFFECT_CURE_CONFUSION
			 || atkPartnerItemEffect == ITEM_EFFECT_CURE_STATUS))
				IncreaseHelpingHandViability(&viability, class);
			break;

		case EFFECT_SANDSTORM:
			if (atkPartnerAbility == ABILITY_SANDVEIL
			|| atkPartnerAbility == ABILITY_SANDRUSH
			|| atkPartnerAbility == ABILITY_SANDFORCE
			|| atkPartnerAbility == ABILITY_OVERCOAT
			|| atkPartnerAbility == ABILITY_MAGICGUARD
			|| atkPartnerItemEffect == ITEM_EFFECT_SAFETY_GOGGLES
			|| IsOfType(bankAtkPartner, TYPE_ROCK)
			|| IsOfType(bankAtkPartner, TYPE_STEEL) 
			|| IsOfType(bankAtkPartner, TYPE_GROUND)
			|| MoveInMoveset(MOVE_SHOREUP, bankAtkPartner)
			|| MoveInMoveset(MOVE_WEATHERBALL, bankAtkPartner))
			{
				if (IsClassDoublesTeamSupport(class))
					INCREASE_VIABILITY(17);
				else
					INCREASE_STATUS_VIABILITY(2);
			}
			break;
			
		case EFFECT_RAIN_DANCE:
			if (MoveEffectInMoveset(EFFECT_THUNDER, bankAtkPartner)
			|| MoveInMoveset(MOVE_WEATHERBALL, bankAtkPartner)
			|| atkPartnerItemEffect == ITEM_EFFECT_DAMP_ROCK
			|| atkPartnerAbility == ABILITY_SWIFTSWIM
			|| atkPartnerAbility == ABILITY_FORECAST
			|| atkPartnerAbility == ABILITY_HYDRATION
			|| atkPartnerAbility == ABILITY_RAINDISH
			|| atkPartnerAbility == ABILITY_DRYSKIN
			|| MoveEffectInMoveset(EFFECT_THUNDER, bankAtkPartner) //Includes Hurricane
			|| MoveInMoveset(MOVE_WEATHERBALL, bankAtkPartner)
			|| MoveTypeInMoveset(TYPE_WATER, bankAtkPartner))
			{
				if (IsClassDoublesTeamSupport(class))
					INCREASE_VIABILITY(17);
				else
					INCREASE_STATUS_VIABILITY(2);
			}
			break;
			
		case EFFECT_SUNNY_DAY:
			if (atkPartnerAbility == ABILITY_CHLOROPHYLL
			|| atkPartnerAbility == ABILITY_FLOWERGIFT
			|| atkPartnerAbility == ABILITY_FORECAST
			|| atkPartnerAbility == ABILITY_LEAFGUARD
			|| atkPartnerAbility == ABILITY_SOLARPOWER
			|| atkPartnerAbility == ABILITY_HARVEST
			|| MoveEffectInMoveset(EFFECT_SOLARBEAM, bankAtkPartner)
			|| MoveEffectInMoveset(EFFECT_MORNING_SUN, bankAtkPartner)
			|| MoveInMoveset(MOVE_WEATHERBALL, bankAtkPartner)
			|| MoveInMoveset(MOVE_GROWTH, bankAtkPartner)
			|| MoveTypeInMoveset(TYPE_FIRE, bankAtkPartner))
			{
				if (IsClassDoublesTeamSupport(class))
					INCREASE_VIABILITY(17);
				else
					INCREASE_STATUS_VIABILITY(2);
			}
			break;
			
		case EFFECT_HAIL:
			if (atkPartnerAbility == ABILITY_SNOWCLOAK
			|| atkPartnerAbility == ABILITY_ICEBODY
			|| atkPartnerAbility == ABILITY_FORECAST
			|| atkPartnerAbility == ABILITY_SLUSHRUSH
			|| atkPartnerAbility == ABILITY_MAGICGUARD
			|| atkPartnerAbility == ABILITY_OVERCOAT
			|| MoveInMoveset(MOVE_BLIZZARD, bankAtkPartner)
			|| MoveInMoveset(MOVE_AURORAVEIL, bankAtkPartner)
			|| MoveInMoveset(MOVE_WEATHERBALL, bankAtkPartner))
			{
				if (IsClassDoublesTeamSupport(class))
					INCREASE_VIABILITY(17);
				else
					INCREASE_STATUS_VIABILITY(2);
			}
			break;
			
		case EFFECT_BEAT_UP:
			if (atkPartnerAbility == ABILITY_JUSTIFIED
			&&  moveType == TYPE_DARK
			&&  moveSplit != SPLIT_STATUS
			&&  PhysicalMoveInMoveset(bankAtkPartner)
			&&  STAT_CAN_RISE(bankAtkPartner, STAT_STAGE_ATK)
			&&  !MoveKnocksOutXHits(move, bankAtk, bankAtkPartner, 1))
				INCREASE_VIABILITY(1); //1 past the previous boost
			break;
	
		case EFFECT_HELPING_HAND:
			if (partnerMove != MOVE_NONE
			&& !partnerProtects
			&&  SPLIT(partnerMove) != SPLIT_STATUS)
			{
				IncreaseHelpingHandViability(&viability, class);
			}
			break;
			
		case EFFECT_SKILL_SWAP:
		case EFFECT_ROLE_PLAY:
			atkAbility = *GetAbilityLocation(bankAtk); //Get actual abilities

			bool8 attackerHasBadAbility = atkAbility == ABILITY_TRUANT
									   || atkAbility == ABILITY_SLOWSTART
									   || atkAbility == ABILITY_DEFEATIST;

			bool8 partnerHasBadAbility = atkPartnerAbility == ABILITY_TRUANT
									  || atkPartnerAbility == ABILITY_SLOWSTART
									  || atkPartnerAbility == ABILITY_DEFEATIST;

			switch (move) {
				case MOVE_WORRYSEED:
				case MOVE_GASTROACID:
				case MOVE_SIMPLEBEAM:
					if (!partnerProtects && partnerHasBadAbility)
						IncreaseHelpingHandViability(&viability, class);
					break;
	
				case MOVE_ENTRAINMENT:
					if (!partnerProtects && partnerHasBadAbility && gAbilityRatings[atkAbility] >= 0)
						IncreaseHelpingHandViability(&viability, class);
					break;

				case MOVE_SKILLSWAP:
					if (!partnerProtects && !attackerHasBadAbility && partnerHasBadAbility)
						IncreaseHelpingHandViability(&viability, class); //Give ability and then switch
					break;

				case MOVE_ROLEPLAY:
					if (!partnerProtects && attackerHasBadAbility && !partnerHasBadAbility)
						IncreaseDoublesDamageViabilityToScore(&viability, class, BEST_DOUBLES_KO_SCORE, bankAtk, bankAtkPartner); //Best move to use
					break;
			}
			break;

		case EFFECT_TYPE_CHANGES:
			if (move == MOVE_SOAK
			&& !partnerProtects
			&&  atkPartnerAbility == ABILITY_WONDERGUARD
			&& (gBattleMons[bankAtkPartner].type1 != TYPE_WATER
			 || gBattleMons[bankAtkPartner].type2 != TYPE_WATER
			 || gBattleMons[bankAtkPartner].type3 != TYPE_WATER))
			{
				IncreaseHelpingHandViability(&viability, class); //Make Pokemon with Wonder Guard the water type for less weaknesses
			}
			break;

		case EFFECT_HEAL_TARGET:
			if (!partnerProtects)
				IncreaseHealPartnerViability(&viability, class, bankAtkPartner);
			break;

		case EFFECT_FIELD_EFFECTS:
			switch (move) {
				case MOVE_IONDELUGE: ;
					u16 foe1Move = IsValidMovePrediction(foe1, bankAtkPartner);
					u16 foe2Move = IsValidMovePrediction(foe1, bankAtkPartner);
					
					if (atkPartnerAbility == ABILITY_VOLTABSORB
					|| atkPartnerAbility == ABILITY_MOTORDRIVE
					|| atkPartnerAbility == ABILITY_LIGHTNINGROD)
					{
						if (foe1Move != MOVE_NONE && GetMoveTypeSpecial(foe1, foe1Move) == TYPE_NORMAL
						&& !DoesProtectionMoveBlockMove(foe1, bankAtkPartner, foe1Move, partnerMove))
							INCREASE_STATUS_VIABILITY(2);
						else if (foe2Move != MOVE_NONE && GetMoveTypeSpecial(foe2, foe2Move) == TYPE_NORMAL
						&& !DoesProtectionMoveBlockMove(foe2, bankAtkPartner, foe2Move, partnerMove))
							INCREASE_STATUS_VIABILITY(2);
					}
					break;
			}
			break;
			
		case EFFECT_TEAM_EFFECTS:
			switch (move) {
				case MOVE_MAGNETRISE:
					if (CheckGrounding(bankAtk) == GROUNDED
					&& DamagingAllHitMoveTypeInMoveset(bankAtkPartner, TYPE_GROUND)
					&& !(AI_SpecialTypeCalc(MOVE_EARTHQUAKE, bankAtkPartner, bankAtk) & (MOVE_RESULT_DOESNT_AFFECT_FOE | MOVE_RESULT_NOT_VERY_EFFECTIVE))) //Doesn't resist ground move
						INCREASE_STATUS_VIABILITY(2);
					break;
			}
			break;
			
		case EFFECT_INSTRUCT_AFTER_YOU_QUASH:
			if (!partnerProtects)
			{
				switch (move) {
					case MOVE_AFTERYOU:
						if (!MoveWouldHitFirst(partnerMove, bankAtkPartner, foe1)
						||  !MoveWouldHitFirst(partnerMove, bankAtkPartner, foe2))
						{
							if (gBattleMoves[partnerMove].effect == EFFECT_COUNTER
							||  gBattleMoves[partnerMove].effect == EFFECT_MIRROR_COAT)
								break; //These moves need to go last
						
							IncreaseHelpingHandViability(&viability, class);
						}
						break;

					case MOVE_INSTRUCT: ;
						u16 instructedMove;
						if (!MoveWouldHitFirst(move, bankAtk, bankAtkPartner))
							instructedMove = partnerMove;
						else
							instructedMove = gLastPrintedMoves[bankAtkPartner];

						if (instructedMove != MOVE_NONE
						&& SPLIT(instructedMove) != SPLIT_STATUS
						&&  gBattleMoves[instructedMove].target & (MOVE_TARGET_BOTH | MOVE_TARGET_ALL)) //Use instruct on multi-target moves
						{
							IncreaseHelpingHandViability(&viability, class);
						}
						break;
				}
			}
	}

	return MathMin(viability, 255);
}
