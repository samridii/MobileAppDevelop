abstract class BankAccount {
  final int _accountNumber; // Encapsulation: protected fields
  final String _holderName;
  double _balance;
  final List<String> _transactions = [];

  BankAccount(this._accountNumber, this._holderName, this._balance);

  // Getters and Setters
  int get accountNumber => _accountNumber;
  String get holderName => _holderName;
  double get balance => _balance;

  set balance(double newBalance) {
    if (newBalance >= 0) {
      _balance = newBalance;
    } else {
      print("Balance cannot be negative.");
    }
  }

  //abstraction
  void deposit(double amount);
  void withdraw(double amount);

  void displayInfo() {
    print("Account Number: $_accountNumber");
    print("Holder Name: $_holderName");
    print("Balance: \$${_balance.toStringAsFixed(2)}");
  }

  void addTransaction(String detail) {
    _transactions.add(detail);
  }

  void showTransactions() {
    print("\nTransactions for $_holderName:");
    for (String t in _transactions) {
      print("- $t");
    }
  }

  void calculateInterest() {}
}

//Interface-Polymorphism and Abstraction
abstract class InterestBearing {
  void calculateInterest();
}

//Account types
class SavingsAccount extends BankAccount implements InterestBearing {
  int _withdrawCount = 0;
  static const int _withdrawLimit = 3;
  static const double _minBalance = 500.0;

  SavingsAccount(super.number, super.name, super.balance);

  @override
  void deposit(double amount) {
    if (amount <= 0) {
      print(" Deposit must be positive!");
      return;
    }
    balance += amount;
    addTransaction("Deposited \$${amount.toStringAsFixed(2)}");
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) {
      print("Withdrawal must be positive!");
      return;
    }
    if (_withdrawCount >= _withdrawLimit) {
      print(" Withdrawal limit reached!");
      return;
    }
    if (balance - amount < _minBalance) {
      print(" Minimum balance of \$$_minBalance required.");
      return;
    }
    balance -= amount;
    _withdrawCount++;
    addTransaction("Withdrew \$${amount.toStringAsFixed(2)}");
  }

  @override
  void calculateInterest() {
    double interest = balance * 0.02;
    balance += interest;
    addTransaction("Interest added: \$${interest.toStringAsFixed(2)}");
  }
}

class CheckingAccount extends BankAccount {
  static const double _overdraftFee = 35.0;

  CheckingAccount(super.number, super.name, super.balance);

  @override
  void deposit(double amount) {
    if (amount <= 0) {
      print(" Deposit must be positive!");
      return;
    }
    balance += amount;
    addTransaction("Deposited \$${amount.toStringAsFixed(2)}");
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) {
      print(" Withdrawal must be positive!");
      return;
    }
    balance -= amount;
    addTransaction("Withdrew \$${amount.toStringAsFixed(2)}");
    if (balance < 0) {
      balance -= _overdraftFee;
      addTransaction("Overdraft fee of \$$_overdraftFee done");
    }
  }
}

class PremiumAccount extends BankAccount implements InterestBearing {
  static const double _minBalance = 10000.0;

  PremiumAccount(super.number, super.name, super.balance);

  @override
  void deposit(double amount) {
    if (amount <= 0) {
      print(" Deposit must be positive!");
      return;
    }
    balance += amount;
    addTransaction("Deposited \$${amount.toStringAsFixed(2)}");
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) {
      print(" Withdrawal must be positive!");
      return;
    }
    if (balance - amount < _minBalance) {
      print(" Minimum balance of \$$_minBalance required!");
      return;
    }
    balance -= amount;
    addTransaction("Withdrew \$${amount.toStringAsFixed(2)}");
  }

  @override
  void calculateInterest() {
    double interest = balance * 0.05;
    balance += interest;
    addTransaction("Interest added: \$${interest.toStringAsFixed(2)}");
  }
}

class StudentAccount extends BankAccount {
  static const double _maxBalance = 5000.0;

  StudentAccount(super.number, super.name, super.balance);

  @override
  void deposit(double amount) {
    if (amount <= 0) {
      print(" Deposit must be positive!");
      return;
    }
    if (balance + amount > _maxBalance) {
      print(" Cannot exceed maximum balance of \$$_maxBalance!");
      return;
    }
    balance += amount;
    addTransaction("Deposited \$${amount.toStringAsFixed(2)}");
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) {
      print("Withdrawal must be positive!");
      return;
    }
    if (balance - amount < 0) {
      print("Insufficient funds");
      return;
    }
    balance -= amount;
    addTransaction("Withdrew \$${amount.toStringAsFixed(2)}");
  }
}

//Bank Class
class Bank {
  final List<BankAccount> _accounts = [];

  void createAccount(BankAccount account) {
    _accounts.add(account);
    print("${account.holderName}'s account is created.");
  }

  BankAccount? findAccount(int accountNumber) {
    for (BankAccount acc in _accounts) {
      if (acc.accountNumber == accountNumber) {
        return acc;
      }
    }
    print("Account not found");
    return null;
  }

  void transfer(int fromAccNum, int toAccNum, double amount) {
    BankAccount? from = findAccount(fromAccNum);
    BankAccount? to = findAccount(toAccNum);

    if (from == null || to == null) {
      print(" Transfer failed: Account not found");
      return;
    }

    if (amount <= 0) {
      print(" Transfer amount must be positive!");
      return;
    }

    if (from.balance < amount) {
      print(" Transfer failed: Insufficient funds");
      return;
    }

    from.withdraw(amount);
    to.deposit(amount);
    print(
      " Transferred \$${amount.toStringAsFixed(2)} from ${from.holderName} to ${to.holderName}",
    );
  }

  void applyMonthlyInterest() {
    for (BankAccount acc in _accounts) {
      if (acc is InterestBearing) {
        acc.calculateInterest();
      }
    }
    print("\n Monthly interest applied to interest accounts");
  }

  void showAllAccounts() {
    print("\nAll Bank Accounts:");
    for (BankAccount acc in _accounts) {
      acc.displayInfo();
    }
  }
}

//functions
void main() {
  Bank bank = Bank();

  SavingsAccount acc1 = SavingsAccount(1, "Ram", 2000.0);
  CheckingAccount acc2 = CheckingAccount(2, "Shyam", 2000.0);
  PremiumAccount acc3 = PremiumAccount(3, "Sam", 15000.0);
  StudentAccount acc4 = StudentAccount(4, "Matt", 20000.0);

  bank.createAccount(acc1);
  bank.createAccount(acc2);
  bank.createAccount(acc3);
  bank.createAccount(acc4);

  acc1.withdraw(200);
  acc1.withdraw(200);
  acc1.deposit(300);
  acc2.withdraw(500);
  bank.transfer(3, 4, 500);

  bank.applyMonthlyInterest();

  acc1.showTransactions();
  acc3.showTransactions();
  bank.showAllAccounts();
}
