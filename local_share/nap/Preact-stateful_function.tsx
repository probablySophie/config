
// A simple stateful component function
function SimpleStateful()
{
	// Make our state & state setter
	const [ count, setCount ] = useState( 0 );

	return <div>
		<button onClick={_ => setCount(count - 1)}>-</button>
		<span>{count}</span>
		<button onClick={_ => setCount( count + 1 )}>+</button>
	</div>
}
