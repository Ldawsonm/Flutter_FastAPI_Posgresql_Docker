from app.database_services.database import Base
from typing import List
from sqlalchemy import  Column, Integer, Float, String, Enum as SQLEnum, ForeignKey
from sqlalchemy.orm import Mapped, relationship, mapped_column

class Todo(Base):
    __tablename__ = "todos"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)
    description = Column(String)
    priority = Column(Integer)

# class Nutrients(Base):
#     __tablename__ = "nutrients"
#     id = mapped_column(Integer, primary_key=True)
#     calories = Column(Float)
#     protein =  Column(Float)
#     carbs =  Column(Float)
#     fat =  Column(Float)
#     fiber =  Column(Float)
#     unit = Column(String)

# class FoodItem(Base):
#     __tablename__ = "food_items"
#     id = mapped_column(Integer, primary_key=True)
#     fdcId = Column(Integer)
#     description = Column(String)
#     brandOwner = Column(String)
#     dataType = Column(String)
#     nutrients: Mapped[List["Nutrients"]] = relationship()

# class SearchResponse(Base):
#     __tablename__ = "searchresponses"
#     id = mapped_column(Integer, primary_key=True)
#     items = Mapped[List["FoodItem"]] = relationship()
#     page = Column(Integer)
#     page_size = Column(Integer)
#     total_hits = Column(Integer)
#     total_pages = Column(Integer)