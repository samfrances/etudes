
def dijkstra(graph, start_node, end_node):

    costs = _calculate_starting_costs(graph, start_node)
    parents = _calculate_starting_parents(graph, start_node)
    processed = []

    def find_lowest_cost_node(costs):
        lowest_cost = float("inf")
        lowest_cost_node = None
        for node in costs:
            cost = costs[node]
            if cost < lowest_cost and node not in processed:
                lowest_cost = cost
                lowest_cost_node = node
        return lowest_cost_node

    node = find_lowest_cost_node(costs)
    while node is not None:
        cost = costs[node]
        neighbours = graph[node]
        for n in neighbours.keys():
            new_cost = cost + neighbours[n]
            if costs[n] > new_cost:
                costs[n] = new_cost
                parents[n] = node
        processed.append(node)
        node = find_lowest_cost_node(costs)

    return _calculate_final_path(parents, start_node, end_node)


def _calculate_starting_costs(graph, start_node):
    costs = {
        node: float("inf") for node in graph.keys() if node != start_node
    }
    for node in graph[start_node].keys():
        costs[node] = graph[start_node][node]
    return costs

def _calculate_starting_parents(graph, start_node):
    parents = {node: None for node in graph.keys() if node != start_node}
    for node in graph[start_node].keys():
        parents[node] = start_node
    return parents

def _calculate_final_path(parents, start_node, end_node):
    path = [end_node]
    node = end_node
    while node != start_node:
        path.append(parents[node])
        node = parents[node]
    return tuple(reversed(path))
