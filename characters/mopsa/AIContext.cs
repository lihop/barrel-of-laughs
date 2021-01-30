using System;
using System.Collections.Generic;
using FluidHTN;
using FluidHTN.Contexts;
using FluidHTN.Debug;
using FluidHTN.Factory;
using Godot;

public enum WorldState : byte
{
	PlayerEyesClosed,
	HidingSpotChosen,
	AtHidingSpot,
	ReadyOrNot,
}

public class AIContext : BaseContext
{
	public override List<string> MTRDebug { get; set; } = null;
	public override List<string> LastMTRDebug { get; set; } = null;
	public override bool DebugMTR { get; } = false;
	public override Queue<IBaseDecompositionLogEntry> DecompositionLog { get; set; } = null;
	public override bool LogDecomposition { get; } = false;

	public override IFactory Factory { get; set; } = new DefaultFactory();
	private byte[] _worldState = new byte[Enum.GetValues(typeof(WorldState)).Length];
	public override byte[] WorldState => _worldState;

	public AIAgent<AIContext> Agent;
	public Vector3[] CurrentPath;
	public int PathNode = 0;

	public StaticBody PreviousHidingSpot { get; set; }

	private StaticBody hidingSpot;

	public StaticBody HidingSpot
	{
		get { return hidingSpot; }
		set
		{
			if (Agent is KinematicBody k)
			{
				if (hidingSpot != null)
				{
					hidingSpot.RemoveCollisionExceptionWith(k);
					k.RemoveCollisionExceptionWith(hidingSpot);
					PreviousHidingSpot = hidingSpot;
				}

				if (value != null)
				{
					value.AddCollisionExceptionWith(k);
					k.AddCollisionExceptionWith(value);
				}
			}

			hidingSpot = value;
		}
	}

	public bool Done { get; set; } = false;

	public bool HasState(WorldState state, bool value)
	{
		return HasState((int)state, (byte)(value ? 1 : 0));
	}

	public bool HasState(WorldState state)
	{
		return HasState((int)state, 1);
	}

	public void SetState(WorldState state, bool value, EffectType type)
	{
		SetState((int)state, (byte)(value ? 1 : 0), true, type);
	}

	public override void Init()
	{
		base.Init();
	}

	public AIContext(AIAgent<AIContext> agent)
	{
		Agent = agent;
		Init();
	}
}
