#!mainFile "framework.opy"
rule "<tx0C00000000001344> Effects <tx0C00000000001344>":
    @Delimiter

def EffectsCreate():
    @Name "Effects | SUB Create Object Effects"
    if len(CustomPortalStart):
        for TempIterator1 in range(len(CustomPortalStart)):
            createEffect(
                #localSpectator(localPlayer.checkpoint_current == CustomPortalCP[evalOnce(TempIterator1)] or CustomPortalCP[evalOnce(TempIterator1)] == -1), #$$ Testing
                [i for i in getAllPlayers() if i.checkpoint_current == evalOnce(CustomPortalCP[TempIterator1]) or evalOnce(CustomPortalCP[TempIterator1] < 0)],
                Effect.GOOD_AURA, ColorConfig[customize.portal], CustomPortalStart[TempIterator1], 0.6, EffectReeval.VISIBILITY)
            wait()
        wait(0.5)

    if len(KillBallPositions):
        for TempIterator1 in range(0, len(KillBallPositions)):
            createEffect(
                #localSpectator(localPlayer.checkpoint_current == KillballCheckpoints[evalOnce(TempIterator1)]), #$$ Testing
                [x for x in getAllPlayers() if x.checkpoint_current == evalOnce(KillballCheckpoints[TempIterator1])],
                Effect.SPHERE, ColorConfig[customize.killorb], KillBallPositions[TempIterator1], abs(KillBallRadii[TempIterator1]), EffectReeval.VISIBILITY)
            wait()
        wait(0.5)

    if len(BouncePositions):
        for TempIterator1 in range(0, len(BouncePositions)):
            createEffect(
                #localSpectator(localPlayer.checkpoint_current == BouncePadCheckpoints[evalOnce(TempIterator1)] and not (evalOnce(TempIterator1) in x.cache_collectedLocks)), #$$ Testing
                [x for x in getAllPlayers().concat(0) if x.checkpoint_current == evalOnce(BouncePadCheckpoints[TempIterator1]) and not (evalOnce(TempIterator1) in x.cache_collectedLocks)],
                Effect.ORB, ColorConfig[customize.orb_lock] if BounceToggleLock[TempIterator1] else ColorConfig[customize.orb_normal], BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
            wait()
    # End portal preview
    createEffect(
        localPlayer if
            localPlayer.preview_i and
            localPlayer.preview_i > len(localPlayer.cache_bouncePosition) and
            localPlayer.preview_array2[localPlayer.preview_i].last()
            else null,
        Effect.SPARKLES,
        Color.PURPLE,
        localPlayer.preview_array1[localPlayer.preview_i],
        0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS
    )

def RebuildBounceOrbs(): # triggers in editor. delets the current orbs to place ones that can be modified. orginal orbs in "SUB | Bounce Ball Effects"
    @Name "Effects | SUB Rebuild Bounce Orbs"
    destroyEffect(BounceEffects)
    BounceEffects = []
    for TempIterator1 in range(0, len(BouncePadCheckpoints)):
        createEffect(
            [x for x in getAllPlayers().concat(null) if x.checkpoint_current == BouncePadCheckpoints[evalOnce(TempIterator1)] and not (evalOnce(TempIterator1) in x.cache_collectedLocks)],
            Effect.ORB,
            ColorConfig[customize.orb_lock] if BounceToggleLock[evalOnce(TempIterator1)] else ColorConfig[customize.orb_normal],
            BouncePositions[evalOnce(TempIterator1)],
            1,
            EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR
        )
        BounceEffects.append(getLastCreatedEntity())
        #wait()
        if not (TempIterator1 % 5):
            wait()

def RebuildKillOrbs(): # triggers in editor. delets the current orbs to place ones that can be modified. orginal orbs in "SUB | Kill Orb Effects"
    @Name "Effects | SUB Rebuild Kill Orbs"
    destroyEffect(KillBallEffects)
    KillBallEffects = []
    for TempIterator1 in range(0, len(KillballCheckpoints)):
        createEffect([x for x in getAllPlayers().concat(null) if x.checkpoint_current == KillballCheckpoints[evalOnce(TempIterator1)]], Effect.SPHERE, ColorConfig[customize.killorb], KillBallPositions[evalOnce(TempIterator1)], abs(KillBallRadii[evalOnce(TempIterator1)]), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        KillBallEffects.append(getLastCreatedEntity())
        if not (TempIterator1 % 5):
            wait()

def RebuildPortals():
    @Name "Effects | SUB Rebuild Portals"
    destroyEffect(PortalEffects)
    PortalEffects = []
    if len(CustomPortalCP):
        for TempIterator1 in range(0, len(CustomPortalCP)):
            createEffect(
                [i for i in getAllPlayers() if i.checkpoint_current == CustomPortalCP[evalOnce(TempIterator1)] or CustomPortalCP[evalOnce(TempIterator1)] < 0],
                Effect.GOOD_AURA,
                ColorConfig[customize.portal],
                CustomPortalStart[evalOnce(TempIterator1)],
                0.6,
                EffectReeval.VISIBILITY_POSITION_AND_RADIUS
            )
            PortalEffects.append(getLastCreatedEntity())
            if not (TempIterator1 % 5):
                wait()