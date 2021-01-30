using FluidHTN;

public interface AIAgent<T> where T : IContext
{
	T Context { get; }
	Domain<T> Domain { get; }
	Planner<T> Planner { get; }
}
