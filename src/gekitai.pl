:- consult('board.pl').
:- consult('display.pl').
:- consult('input.pl').
:- consult('game.pl').
:- consult('utils.pl').
:-use_module(library(lists)).


%main predicate
play :-
    start. 