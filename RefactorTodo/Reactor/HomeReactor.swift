import Foundation
import RxSwift
import ReactorKit

class HomeReactor: Reactor {
    weak var homeCoordinator: HomeCoorinator?
    
    init(homeCoordinator: HomeCoorinator?) {
        self.homeCoordinator = homeCoordinator
    }
    
    struct State {
        var isAddViewPresent: Bool = false
        var existTodos: [TodoModel] = []
    }
    
    enum Action {
        case moveToAddView(Date)
        case addTodo
        case loadAllTodosByYearMonth(Date)
    }
    
    enum Mutation {
        case moveToAddView(Date)
        case addTodo
        case loadAllTodosByYearMonth([TodoModel])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .moveToAddView(let date):
            homeCoordinator?.moveToAddTodo(selected: date)
            return .empty()
        case .addTodo:
            return .empty()
        case .loadAllTodosByYearMonth(let date):
            return CoreDataService.shared.loadTodosBy(yearMonth: date.dateToString(includeDay: .month))
                .map { Mutation.loadAllTodosByYearMonth($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .loadAllTodosByYearMonth(let todos):
            newState.existTodos = todos
        default:
            break
        }
        
        return newState
    }
    
    let initialState: State = State()
}
