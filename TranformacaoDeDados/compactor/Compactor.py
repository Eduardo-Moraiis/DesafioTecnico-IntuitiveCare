from abc import abstractmethod, ABC


class Compactor(ABC):
    @abstractmethod
    def extract(self, filePath, destinyPath) -> None:
        pass
