using FluidHTN;
using Godot;

public class Hider : KinematicBody, AIAgent<AIContext>
{
	[Export]
	public int Speed = 5;

	[Export]
	public float Gravity = 100;

	[Signal]
	public delegate void Found();

	public AIContext Context { get; private set; }
	public Domain<AIContext> Domain { get; private set; }
	public Planner<AIContext> Planner { get; private set; }

	private bool countdownStarted = false;
	private bool found = false;

	public override void _Ready()
	{
		Context = new AIContext(this);
		Domain = new HiderDomain().Create();
		Planner = new Planner<AIContext>();

		GetNode("/root/Events").Connect("player_closed_eyes", this, "OnPlayerClosedEyes");
		GetNode("/root/Events").Connect("player_opened_eyes", this, "OnPlayerOpenedEyes");
		GetNode("/root/Events").Connect("countdown_completed", this, "OnPlayerComing");
	}

	public override void _PhysicsProcess(float _delta)
	{
		Planner.Tick(Domain, Context);
	}

	public void OnPlayerClosedEyes()
	{
		if (!countdownStarted)
			countdownStarted = true;

		Context.SetState(WorldState.PlayerEyesClosed, true, EffectType.Permanent);
	}

	public void OnPlayerOpenedEyes()
	{
		Context.SetState(WorldState.PlayerEyesClosed, false, EffectType.Permanent);

		GD.Print("Player opened eyes!");

		if (countdownStarted && Context.HasState(WorldState.ReadyOrNot, false))
			OnPlayerPeeked();
	}

	public void OnPlayerPeeked()
	{
		GD.Print("Player peeked!");
		GetNode("Mouth").Call("say", "hey_no_peeking");
		var animationPlayer = GetNode<AnimationPlayer>("Model/AnimationPlayer");
		animationPlayer.Stop();

		if (Context.HasState(WorldState.AtHidingSpot, false))
		{
			GD.Print("Not at hiding spot! Reset all");
			Context.HidingSpot = null;
			Context.SetState(WorldState.ReadyOrNot, false, EffectType.Permanent);
			Context.SetState(WorldState.HidingSpotChosen, false, EffectType.Permanent);
			Context.CurrentPath = null;
			Context.PathNode = 0;
		}
	}

	public void Find()
	{
		if (!found)
		{
			found = true;
			GetNode("Mouth").Call("say", "you_found_me", true);
			var animationPlayer = GetNode<AnimationPlayer>("Model/AnimationPlayer");
			animationPlayer.CurrentAnimation = "Cheer";
			animationPlayer.Play();
			EmitSignal(nameof(Found));
		}
	}

	public void Reset()
	{
		found = false;
		Context.SetState(WorldState.ReadyOrNot, false, EffectType.Permanent);
		Context.SetState(WorldState.AtHidingSpot, false, EffectType.Permanent);
		Context.SetState(WorldState.HidingSpotChosen, false, EffectType.Permanent);
		Context.SetState(WorldState.PlayerEyesClosed, false, EffectType.Permanent);
		Context.CurrentPath = null;
		Context.PathNode = 0;
	}

	public void OnPlayerComing() => Context.SetState(WorldState.ReadyOrNot, true, EffectType.Permanent);
}
